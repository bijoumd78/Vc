#include <cstdio>
#include <cstdlib>

#include "math.h"
#include "vector.h"

int main()
{
    float data[32];
    float result[32];
    // initialize data
    for(std::size_t i = 0; i < 32; ++i)
    {
        data[i] = i * i;
        result[i] = .0f;
    }

    // allocate memory on device
    float *devData;
    float *devResult;
    cudaMalloc(&devData, sizeof(float) * CUDA_VECTOR_SIZE);
    cudaMalloc(&devResult, sizeof(float) * CUDA_VECTOR_SIZE);

    // copy data to device
    cudaMemcpy(devData, data, sizeof(float) * CUDA_VECTOR_SIZE, cudaMemcpyHostToDevice);

    // create vector from data
    Vc::CUDA::Vector<float> inVec(devData);

    // computation
    Vc::CUDA::Vector<float> outVec = Vc::CUDA::sqrt(inVec);

    // fetch result from vector
    outVec.store(devResult);

    // copy to host
    cudaMemcpy(result, devResult, sizeof(float) * CUDA_VECTOR_SIZE, cudaMemcpyDeviceToHost);

    // print results
    for(std::size_t i = 0; i < 32; ++i)
        printf("sqrt(%f) = %f\n", data[i], result[i]);
 
    cudaFree(devResult);
    cudaFree(devData);

    return 0;
}

