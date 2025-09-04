// Minimal SGP4 + FOV check harness
// - Propagates with SGP4 using repo sources
// - Computes LVLH from scRECI/scVECI
// - Applies Euler offset to get body orientation
// - Checks if Earth or Sun lies within provided sensor FOVs

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <algorithm>

// ADCS headers
#include <gs/adcs/adcs_param_types.h>
#include <gs/adcs/adcs_telem_types.h>
#include <gs/adcs/ephemeris/GS_ADCS_EPHEM.h>
extern "C" {
#include <ephem/GS_ADCS_TLE.h>
}
#include <gs/adcs/math/GS_MatLib.h>

// Sun vector helper (compiled as C++ due to toolchain here)
void GS_ADCS_SUN(double julianDate, float* sunVecECI);

static inline void normalize3(float v[3]) {
    float n = sqrtf(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    if (n > 0.0f) { v[0]/=n; v[1]/=n; v[2]/=n; }
}

// Build LVLH quaternion (ECI->LVLH) from ECI position/velocity, same convention as GS_ACDS_qIO
static quaternion_t lvlh_from_state(const gs_adcs_ephem_t& e) {
    float X[3], Y[3], Z[3];
    float R[9];

    // Z toward nadir: -R/|R|
    Z[0] = -e.scRECI[0]; Z[1] = -e.scRECI[1]; Z[2] = -e.scRECI[2];
    mNormalize(Z, 3);

    // Y along orbit angular momentum: Z x V / |Z x V|
    float V[3] = { e.scVECI[0], e.scVECI[1], e.scVECI[2] };
    mNormalize(V, 3);
    Y[0] = Z[1]*V[2] - V[1]*Z[2];
    Y[1] = Z[2]*V[0] - V[2]*Z[0];
    Y[2] = Z[0]*V[1] - V[0]*Z[1];
    mNormalize(Y, 3);

    // X completes RHS: X = Y x Z
    X[0] = Y[1]*Z[2] - Z[1]*Y[2];
    X[1] = Y[2]*Z[0] - Z[2]*Y[0];
    X[2] = Y[0]*Z[1] - Z[0]*Y[1];
    mNormalize(X, 3);

    // Rotation matrix columns are LVLH basis expressed in ECI
    R[0] = X[0]; R[3] = X[1]; R[6] = X[2];
    R[1] = Y[0]; R[4] = Y[1]; R[7] = Y[2];
    R[2] = Z[0]; R[5] = Z[1]; R[8] = Z[2];

    return RotMatrixToQuaternion(R);
}

// Simple JD utility (UTC) using algorithm for Gregorian calendar
static double jd_from_ymdhms(int Y, int M, int D, int h, int m, double s) {
    if (M <= 2) { Y -= 1; M += 12; }
    int A = Y/100; int B = 2 - A + A/4;
    double day = D + (h + (m + s/60.0)/60.0) / 24.0;
    long long C = (long long)floor(365.25*(Y + 4716));
    long long E = (long long)floor(30.6001*(M + 1));
    return C + E + day + B - 1524.5;
}

// Returns true if dir_body within half-angle fov_rad of boresight_body
static bool in_fov(const float boresight_body[3], float fov_half_angle_rad, const float dir_body[3]) {
    float bs[3] = {boresight_body[0], boresight_body[1], boresight_body[2]};
    float dv[3] = {dir_body[0], dir_body[1], dir_body[2]};
    normalize3(bs); normalize3(dv);
    float c = bs[0]*dv[0] + bs[1]*dv[1] + bs[2]*dv[2];
    float ang = acosf(fmaxf(-1.0f, fminf(1.0f, c)));
    return ang <= fov_half_angle_rad;
}

// Single-step propagate + report helper
static void propagate_and_report(gs_adcs_config_t &conf,
                                 float euler_offset[3],
                                 const float startracker_boresight[3], float startracker_fov_deg,
                                 const float payload_boresight[3], float payload_fov_deg,
                                 int Y, int M, int D, int h, int mi, double s) {
    double jd = jd_from_ymdhms(Y, M, D, h, mi, s);

    gs_adcs_ephem_t ephem = {};
    ephem.julianDate = jd;

    int ierr = GS_ADCS_SGP4Pos(&conf, ephem.julianDate, &ephem);
    if (ierr) {
        std::fprintf(stderr, "SGP4 update error: %d\n", ierr);
        return;
    }

    quaternion_t qIL = lvlh_from_state(ephem);
    quaternion_t qOffset = EulerToQuaternion(euler_offset);
    quaternion_t qBody = qMult(qIL, qOffset); // ECI->Body

    float toEarthECI[3] = { -ephem.scRECI[0], -ephem.scRECI[1], -ephem.scRECI[2] };
    normalize3(toEarthECI);

    float sunECI[3];
    GS_ADCS_SUN(ephem.julianDate, sunECI);
    float toSunECI[3] = { sunECI[0] - ephem.scRECI[0], sunECI[1] - ephem.scRECI[1], sunECI[2] - ephem.scRECI[2] };
    normalize3(toSunECI);

    // Eclipse check (cylindrical umbra approximation similar to GS code)
    bool in_eclipse = false;
    {
        const float Rearth = 6384000.0f;
        // Sun shadow unit vector (points from Sun to Earth)
        float sun_vec_unit[3] = { -sunECI[0], -sunECI[1], -sunECI[2] };
        normalize3(sun_vec_unit);
        // Spacecraft unit vector from Earth
        float rnorm = sqrtf(ephem.scRECI[0]*ephem.scRECI[0] + ephem.scRECI[1]*ephem.scRECI[1] + ephem.scRECI[2]*ephem.scRECI[2]);
        float reci_unit[3] = { ephem.scRECI[0]/rnorm, ephem.scRECI[1]/rnorm, ephem.scRECI[2]/rnorm };
        // Night side if projection onto sun shadow is positive
        float dot_ns = sun_vec_unit[0]*reci_unit[0] + sun_vec_unit[1]*reci_unit[1] + sun_vec_unit[2]*reci_unit[2];
        if (dot_ns > 0.0f) {
            // Distance from spacecraft to shadow axis: |sun_vec_unit x r|
            float cx = sun_vec_unit[1]*ephem.scRECI[2] - ephem.scRECI[1]*sun_vec_unit[2];
            float cy = sun_vec_unit[2]*ephem.scRECI[0] - ephem.scRECI[2]*sun_vec_unit[0];
            float cz = sun_vec_unit[0]*ephem.scRECI[1] - ephem.scRECI[0]*sun_vec_unit[1];
            float dist = sqrtf(cx*cx + cy*cy + cz*cz);
            in_eclipse = (dist < Rearth);
        }
    }

    float toEarthBody[3] = { toEarthECI[0], toEarthECI[1], toEarthECI[2] };
    float toSunBody[3]   = { toSunECI[0],   toSunECI[1],   toSunECI[2]   };
    // Rotate ECI -> Body by passing qBI (Body->ECI) to vecRotQ
    vecRotQ(toEarthBody, qBody);
    vecRotQ(toSunBody,   qBody);

    float st_half = (startracker_fov_deg * (float)M_PI/180.0f) * 0.5f;
    float pl_half = (payload_fov_deg    * (float)M_PI/180.0f) * 0.5f;

    bool earth_in_st = in_fov(startracker_boresight, st_half, toEarthBody);
    bool sun_in_st   = in_fov(startracker_boresight, st_half, toSunBody);
    bool earth_in_pl = in_fov(payload_boresight,     pl_half, toEarthBody);
    bool sun_in_pl   = in_fov(payload_boresight,     pl_half, toSunBody);

    std::printf("Time (UTC): %04d-%02d-%02d %02d:%02d:%06.3f  JD=%.6f\n", Y,M,D,h,mi,s,jd);
    std::printf("Eclipse:     %s\n", in_eclipse?"YES":"NO");
    std::printf("StarTracker: Earth:%s  Sun:%s\n", earth_in_st?"IN":"OUT", sun_in_st?"IN":"OUT");
    std::printf("Payload:     Earth:%s  Sun:%s\n\n", earth_in_pl?"IN":"OUT", sun_in_pl?"IN":"OUT");
}

int main(int argc, char** argv) {
    // 1) Configure TLE (edit these as needed)
    const char* TLE1 = "1 62400U 24247Z   25245.19006697  .00013198  00000-0  55165-3 0  9994";
    const char* TLE2 = "2 62400  44.9958  62.9780 0004417 289.9126  70.1279 15.23624536 38945";

    // 2) Define sensor boresights (body frame) and FOVs (degrees)
    // Replace with your values
    float startracker_boresight[3] = {-1.0f, 0.0f, 0.0f};
    float startracker_fov_deg = 90.0f; // full cone angle
    float payload_boresight[3] = {0.0f, 0.0f, 1.0f};
    float payload_fov_deg = 3.0f; // full cone angle

    // 3) Define LVLH->body Euler offset (rad), 3-2-1 (X-Y-Z used by EulerToQuaternion in this codebase)
    float euler_offset[3] = {
        120.0 * M_PI / 180.0,     // X rotation
        -40.0 * M_PI / 180.0,     // Y rotation
        -100.0 * M_PI / 180.0     // Z rotation
    };

    // 4) Time selection: support single, start+count, or start..end stepped
    int Y=2025, M=9, D=3, h=0, mi=0; double s=0.0;
    // Modes:
    //  - Single:             prog Y M D h m s
    //  - Start+count:        prog Y M D h m s step_s count
    //  - Start..End stepped: prog Y M D h m s Y2 M2 D2 h2 m2 s2 step_s

    // 5) Minimal config with TLE lines
    gs_adcs_config_gnc_t gnc_mem = {};
    // Set only the fields used by SGP4
    strncpy(gnc_mem.common.tleline1, TLE1, sizeof(gnc_mem.common.tleline1)-1);
    strncpy(gnc_mem.common.tleline2, TLE2, sizeof(gnc_mem.common.tleline2)-1);
    gnc_mem.common.teme2eci = true; // Apply TEME->ECI conversion inside SGP4
    gnc_mem.common.ephem_divider = 1;
    gnc_mem.common.sampletime = 100; // ms (unused here)

    gs_adcs_config_t conf = {};
    conf.gnc = &gnc_mem;

    // 6) Initialize SGP4
    int ierr = GS_ADCS_SGP4Init(&conf);
    if (ierr) {
        std::fprintf(stderr, "SGP4 init error: %d\n", ierr);
        return 1;
    }
    // 7) Dispatch per mode
    if (argc == 7) {
        // Single timestamp
        Y = atoi(argv[1]); M = atoi(argv[2]); D = atoi(argv[3]);
        h = atoi(argv[4]); mi = atoi(argv[5]); s = atof(argv[6]);
        propagate_and_report(conf, euler_offset,
                             startracker_boresight, startracker_fov_deg,
                             payload_boresight, payload_fov_deg,
                             Y, M, D, h, mi, s);
    } else if (argc == 9) {
        // Start + step + count
        Y = atoi(argv[1]); M = atoi(argv[2]); D = atoi(argv[3]);
        h = atoi(argv[4]); mi = atoi(argv[5]); s = atof(argv[6]);
        double step_s = atof(argv[7]);
        int count = atoi(argv[8]);
        if (step_s <= 0 || count <= 0) {
            std::fprintf(stderr, "Invalid step or count.\n");
            return 2;
        }
        int YY = Y, MM = M, DD = D, hh = h, mm = mi; double ss = s;
        for (int i = 0; i < count; ++i) {
            propagate_and_report(conf, euler_offset,
                                 startracker_boresight, startracker_fov_deg,
                                 payload_boresight, payload_fov_deg,
                                 YY, MM, DD, hh, mm, ss);
            // advance simple clock by step_s for printing
            double x = ss + step_s; int day_carry = 0;
            while (x >= 60.0) { x -= 60.0; mm++; }
            while (mm >= 60) { mm -= 60; hh++; }
            while (hh >= 24) { hh -= 24; DD++; day_carry = 1; }
            // Note: this does not handle month rollover precisely
            ss = x;
        }
    } else if (argc == 14) {
        // Start..End stepped
        int Y2 = atoi(argv[7]); int M2 = atoi(argv[8]); int D2 = atoi(argv[9]);
        int h2 = atoi(argv[10]); int mi2 = atoi(argv[11]); double s2 = atof(argv[12]);
        double step_s = atof(argv[13]);
        if (step_s <= 0) {
            std::fprintf(stderr, "Invalid step.\n");
            return 2;
        }
        double jd_start = jd_from_ymdhms(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]), atof(argv[6]));
        double jd_end   = jd_from_ymdhms(Y2,M2,D2,h2,mi2,s2);
        if (jd_end < jd_start) std::swap(jd_start, jd_end);
        double jd = jd_start;
        int YY = atoi(argv[1]), MM = atoi(argv[2]), DD = atoi(argv[3]);
        int hh = atoi(argv[4]), mm = atoi(argv[5]); double ss = atof(argv[6]);
        for (; jd <= jd_end + 1e-9; jd += step_s/86400.0) {
            propagate_and_report(conf, euler_offset,
                                 startracker_boresight, startracker_fov_deg,
                                 payload_boresight, payload_fov_deg,
                                 YY, MM, DD, hh, mm, ss);
            double x = ss + step_s;
            while (x >= 60.0) { x -= 60.0; mm++; }
            while (mm >= 60) { mm -= 60; hh++; }
            while (hh >= 24) { hh -= 24; DD++; }
            ss = x;
        }
    } else {
        // Default single run at baked-in time
        propagate_and_report(conf, euler_offset,
                             startracker_boresight, startracker_fov_deg,
                             payload_boresight, payload_fov_deg,
                             Y, M, D, h, mi, s);
    }
    return 0;
}
