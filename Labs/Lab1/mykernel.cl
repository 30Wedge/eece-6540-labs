
/**
 * Perform the matrix operation: D = A x B + C
 *
 * based on the kernel from MatrixMulti
 */
__kernel void multiplyAdd(
    __global float *outputD,
    int widthA,
    int heightA,
    int widthB,
    int heightB,
    int widthC,
    int heightC,
    __global float *inputA,
    __global float *inputB,
    __global float *inputC)
{
    /* not sure if we're allowed an assert, but these conditions
    must be satistfied. If true, C size parameters can be omitted */

    /* have to make this check on the host */
    //assert(widthC == widthB);
    //assert(heightC == heightA);

    /* get global position in Y direction */
    int row = get_global_id (1);
    /* get global position in X direction */
    int col = get_global_id (0);

    float sum = 0.0f;

    /* calculate the result of the multiplication*/
    for (int i=0; i<widthA; i++) {
        sum += inputA[row*widthA + i] * inputB[i*widthB + col];
    }
    /* perform the addition with matrix C*/
    sum += inputC[row*widthB + col];

    outputD[row*widthB + col] = sum;
}
