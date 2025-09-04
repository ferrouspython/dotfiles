#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <math.h>

typedef float adcs_float_t;

typedef struct
{
    float q1; // xi
    float q2; // yj
    float q3; // zk
    float q4; // w (real part)
} quaternion_t;

quaternion_t EulerToQuaternion(adcs_float_t *euler)
{
    quaternion_t q;

    q.q1 = sin(euler[0] / 2.0) * cos(euler[1] / 2.0) * cos(euler[2] / 2.0) - cos(euler[0] / 2.0) * sin(euler[1] / 2.0) * sin(euler[2] / 2.0);
    q.q2 = cos(euler[0] / 2.0) * sin(euler[1] / 2.0) * cos(euler[2] / 2.0) + sin(euler[0] / 2.0) * cos(euler[1] / 2.0) * sin(euler[2] / 2.0);
    q.q3 = cos(euler[0] / 2.0) * cos(euler[1] / 2.0) * sin(euler[2] / 2.0) - sin(euler[0] / 2.0) * sin(euler[1] / 2.0) * cos(euler[2] / 2.0);
    q.q4 = cos(euler[0] / 2.0) * cos(euler[1] / 2.0) * cos(euler[2] / 2.0) + sin(euler[0] / 2.0) * sin(euler[1] / 2.0) * sin(euler[2] / 2.0);

    return q;
}

quaternion_t qMult(quaternion_t B, quaternion_t C)
{
    quaternion_t A;
    A.q1 = B.q4 * C.q1 + B.q1 * C.q4 + B.q2 * C.q3 - B.q3 * C.q2;
    A.q2 = B.q4 * C.q2 - B.q1 * C.q3 + B.q2 * C.q4 + B.q3 * C.q1;
    A.q3 = B.q4 * C.q3 + B.q1 * C.q2 - B.q2 * C.q1 + B.q3 * C.q4;
    A.q4 = B.q4 * C.q4 - B.q1 * C.q1 - B.q2 * C.q2 - B.q3 * C.q3;
    return A;
}

quaternion_t qInv(quaternion_t q)
{
    quaternion_t invq;
    invq.q1 = -q.q1;
    invq.q2 = -q.q2;
    invq.q3 = -q.q3;
    invq.q4 = q.q4;
    return invq;
}

quaternion_t eaa2q(const adcs_float_t *axis, const adcs_float_t angle)
{
    quaternion_t q;

    q.q1 = axis[0] * sin(angle / 2);
    q.q2 = axis[1] * sin(angle / 2);
    q.q3 = axis[2] * sin(angle / 2);
    q.q4 = cos(angle / 2);

    return q;
}

adcs_float_t qNorm(quaternion_t q)
{
    return sqrt(q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3 + q.q4 * q.q4);
}

quaternion_t qNormalize(quaternion_t q)
{
    adcs_float_t qLength;
    quaternion_t qNormalized;

    qLength = qNorm(q);
    if (qLength != 0)
    {
        qNormalized.q1 = q.q1 / qLength;
        qNormalized.q2 = q.q2 / qLength;
        qNormalized.q3 = q.q3 / qLength;
        qNormalized.q4 = q.q4 / qLength;
    }
    else
    {
        qNormalized.q1 = 0;
        qNormalized.q2 = 0;
        qNormalized.q3 = 0;
        qNormalized.q4 = 0;
    }

    return qNormalized;
}

void vecRotQ(adcs_float_t *vec, quaternion_t q)
{
    quaternion_t vectorq;

    // Make vector quaternion
    vectorq.q1 = vec[0];
    vectorq.q2 = vec[1];
    vectorq.q3 = vec[2];
    vectorq.q4 = 0.0;

    // Rotate vector with quaternion
    vectorq = qMult(vectorq, q);
    vectorq = qMult(qInv(q), vectorq);

    // Put the return vector back together again
    vec[0] = vectorq.q1;
    vec[1] = vectorq.q2;
    vec[2] = vectorq.q3;
}

static int vec_equal_eps(const adcs_float_t a[3], const adcs_float_t b[3], adcs_float_t eps)
{
    return (fabsf(a[0] - b[0]) <= eps) &&
           (fabsf(a[1] - b[1]) <= eps) &&
           (fabsf(a[2] - b[2]) <= eps);
}

int main()
{
    printf("Checking euler angle rotations...\n\n");

    adcs_float_t euler_angles[3] = {
        180.0 * M_PI / 180.0,   // X rotation
        -67.0 * M_PI / 180.0,   // Y rotation
        90.0 * M_PI / 180.0     // Z rotation
    };

    quaternion_t q1 = EulerToQuaternion(euler_angles);
    q1 = qNormalize(q1);
    printf("Quaternion(i=%.6f, j=%.6f, k=%.6f, w=%.6f)\n", q1.q1, q1.q2, q1.q3, q1.q4);

    adcs_float_t x[3] = {1.0, 0.0, 0.0};
    adcs_float_t y[3] = {0.0, 1.0, 0.0};
    adcs_float_t z[3] = {0.0, 0.0, 1.0};
    vecRotQ(x, q1);
    vecRotQ(y, q1);
    vecRotQ(z, q1);
    printf("GOMSpace Function Rotated Axis:\n");
    printf("X: [%.1f, %.1f, %.1f]\n", x[0], x[1], x[2]);
    printf("Y: [%.1f, %.1f, %.1f]\n", y[0], y[1], y[2]);
    printf("Z: [%.1f, %.1f, %.1f]\n", z[0], z[1], z[2]);

    adcs_float_t x1[3] = {1.0, 0.0, 0.0};
    adcs_float_t y1[3] = {0.0, 1.0, 0.0};
    adcs_float_t z1[3] = {0.0, 0.0, 1.0};

    quaternion_t qx, qy, qz;
    qz = eaa2q(z1, euler_angles[2]);
    vecRotQ(x1, qz);
    vecRotQ(y1, qz);
    vecRotQ(z1, qz);
    qy = eaa2q(y1, euler_angles[1]);
    vecRotQ(x1, qy);
    vecRotQ(y1, qy);
    vecRotQ(z1, qy);
    qx = eaa2q(x1, euler_angles[0]);
    vecRotQ(x1, qx);
    vecRotQ(y1, qx);
    vecRotQ(z1, qx);

    printf("Z-Y-X Rotated Axis:\n");
    printf("X: [%.1f, %.1f, %.1f]\n", x1[0], x1[1], x1[2]);
    printf("Y: [%.1f, %.1f, %.1f]\n", y1[0], y1[1], y1[2]);
    printf("Z: [%.1f, %.1f, %.1f]\n", z1[0], z1[1], z1[2]);

    adcs_float_t x2[3] = {1.0, 0.0, 0.0};
    adcs_float_t y2[3] = {0.0, 1.0, 0.0};
    adcs_float_t z2[3] = {0.0, 0.0, 1.0};

    qx = eaa2q(x2, euler_angles[0]);
    vecRotQ(x2, qx);
    vecRotQ(y2, qx);
    vecRotQ(z2, qx);
    qy = eaa2q(y2, euler_angles[1]);
    vecRotQ(x2, qy);
    vecRotQ(y2, qy);
    vecRotQ(z2, qy);
    qz = eaa2q(z2, euler_angles[2]);
    vecRotQ(x2, qz);
    vecRotQ(y2, qz);
    vecRotQ(z2, qz);

    printf("X-Y-Z Rotated Axis:\n");
    printf("X: [%.1f, %.1f, %.1f]\n", x2[0], x2[1], x2[2]);
    printf("Y: [%.1f, %.1f, %.1f]\n", y2[0], y2[1], y2[2]);
    printf("Z: [%.1f, %.1f, %.1f]\n", z2[0], z2[1], z2[2]);

    const adcs_float_t eps = 1e-5f;
    if (vec_equal_eps(x,x1,eps) && vec_equal_eps(y,y1,eps) && vec_equal_eps(z,z1,eps)) {
        printf("Euler Angles are applied Z -> Y -> X");
    } else if (vec_equal_eps(x,x1,eps) && vec_equal_eps(y,y1,eps) && vec_equal_eps(z,z1,eps)) {
        printf("Euler Angles are applied X -> Y -> Z");
    }

    return 0;
}
