// Minimal SGP4 + FOV check harness
// - Propagates with SGP4 using repo sources
// - Computes LVLH from scRECI/scVECI
// - Applies Euler offset to get body orientation
// - Checks if Earth or Sun lies within provided sensor FOVs

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>

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

int main(int argc, char** argv) {
    // 1) Configure TLE (edit these as needed)
    const char* TLE1 = "1 62400U 24247Z   25245.19006697  .00013198  00000-0  55165-3 0  9994";
    const char* TLE2 = "2 25544  51.6442  64.0538 0001748  90.7715  53.4826 15.49334793258366";

    // 2) Define sensor boresights (body frame) and FOVs (degrees)
    // Replace with your values
    float startracker_boresight[3] = {-1.0f, 0.0f, 0.0f};
    float startracker_fov_deg = 90.0f; // full cone angle
    float payload_boresight[3] = {0.0f, 0.0f, 1.0f};
    float payload_fov_deg = 3.0f; // full cone angle

    // 3) Define LVLH->body Euler offset (rad), 3-2-1 (X-Y-Z used by EulerToQuaternion in this codebase)
    float euler_offset[3] = {0.0f, 0.0f, 0.0f};

    // 4) Pick propagation time (UTC)
    int Y=2020, M=12, D=10, h=12, mi=0; double s=0.0;
    if (argc == 7) {
        Y = atoi(argv[1]); M = atoi(argv[2]); D = atoi(argv[3]);
        h = atoi(argv[4]); mi = atoi(argv[5]); s = atof(argv[6]);
    }
    double jd = jd_from_ymdhms(Y, M, D, h, mi, s);

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

    // 6) Initialize and propagate
    gs_adcs_ephem_t ephem = {};
    ephem.julianDate = jd;

    int ierr = GS_ADCS_SGP4Init(&conf);
    if (ierr) {
        std::fprintf(stderr, "SGP4 init error: %d\n", ierr);
        return 1;
    }
    ierr = GS_ADCS_SGP4Pos(&conf, ephem.julianDate, &ephem);
    if (ierr) {
        std::fprintf(stderr, "SGP4 update error: %d\n", ierr);
        return 2;
    }

    // 7) LVLH quaternion and body orientation
    quaternion_t qIL = lvlh_from_state(ephem);
    quaternion_t qOffset = EulerToQuaternion(euler_offset);
    quaternion_t qBody = qMult(qIL, qOffset); // ECI->Body

    // 8) Directions in ECI
    // Earth center direction from SC in ECI
    float toEarthECI[3] = { -ephem.scRECI[0], -ephem.scRECI[1], -ephem.scRECI[2] };
    normalize3(toEarthECI);

    // Sun direction from SC in ECI
    float sunECI[3];
    GS_ADCS_SUN(ephem.julianDate, sunECI); // returns Sun position in ECI (meters)
    float toSunECI[3] = { sunECI[0] - ephem.scRECI[0], sunECI[1] - ephem.scRECI[1], sunECI[2] - ephem.scRECI[2] };
    normalize3(toSunECI);

    // 9) Rotate to body frame: v_body = q_inv(qBody) * v_eci * qBody
    float toEarthBody[3] = { toEarthECI[0], toEarthECI[1], toEarthECI[2] };
    float toSunBody[3]   = { toSunECI[0],   toSunECI[1],   toSunECI[2]   };
    vecRotQ(toEarthBody, qInv(qBody));
    vecRotQ(toSunBody,   qInv(qBody));

    // 10) FOV checks
    float st_half = (startracker_fov_deg * (float)M_PI/180.0f) * 0.5f;
    float pl_half = (payload_fov_deg    * (float)M_PI/180.0f) * 0.5f;

    bool earth_in_st = in_fov(startracker_boresight, st_half, toEarthBody);
    bool sun_in_st   = in_fov(startracker_boresight, st_half, toSunBody);
    bool earth_in_pl = in_fov(payload_boresight,     pl_half, toEarthBody);
    bool sun_in_pl   = in_fov(payload_boresight,     pl_half, toSunBody);

    // 11) Report
    std::printf("Time (UTC): %04d-%02d-%02d %02d:%02d:%06.3f  JD=%.6f\n", Y,M,D,h,mi,s,jd);
    std::printf("scRECI [m]:  [%.3f, %.3f, %.3f]\n", ephem.scRECI[0], ephem.scRECI[1], ephem.scRECI[2]);
    std::printf("scVECI [m/s]:[%.3f, %.3f, %.3f]\n", ephem.scVECI[0], ephem.scVECI[1], ephem.scVECI[2]);
    std::printf("qIL: (i=%.6f, j=%.6f, k=%.6f, w=%.6f)\n", qIL.q1, qIL.q2, qIL.q3, qIL.q4);
    std::printf("qBody: (i=%.6f, j=%.6f, k=%.6f, w=%.6f)\n", qBody.q1, qBody.q2, qBody.q3, qBody.q4);
    std::printf("StarTracker: Earth:%s  Sun:%s\n", earth_in_st?"IN":"OUT", sun_in_st?"IN":"OUT");
    std::printf("Payload:     Earth:%s  Sun:%s\n", earth_in_pl?"IN":"OUT", sun_in_pl?"IN":"OUT");

    return 0;
}
