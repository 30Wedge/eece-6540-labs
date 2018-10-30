# Lab 1 Report
*Andy MacGregor*

## Introduction

This lab is an introduction to OpenCL to get practice with kernel design, the OpenCL API and the build process of an OpenCL application. The kernel in question performs the matrix operation **D = A x B + C** on staticly allocated arrays A, B and C manually with dimensions 2x4, 4x6 and 2x6 respectively.

Matrix operations (though not this small) are normally well suited for OpenCL, which makes this task perfect for an introductory project.

## Summary

### Precalculation
First, the correct results for the operation were calculated. The below equation shows the calculations required.

Because each array element is identical, all of the elements will have the same value (11). D should be a 2x6 matrix with each element equal to 11.
``` 
[[ 1, 1, 1, 1 ],   [[2, 2, 2, 2, 2, 2],     [[3, 3, 3, 3, 3, 3],
 [ 1, 1, 1, 1 ]] *  [2, 2, 2, 2, 2, 2],  +   [3, 3, 3, 3, 3, 3]]  =   D
                    [2, 2, 2, 2, 2, 2],
                    [2, 2, 2, 2, 2, 2]]
                    
each cell = (1*2)+ (1*2) +(1*2) + (1*2) = 11


    D =  [[11, 11, 11, 11, 11, 11],
          [11, 11, 11, 11, 11, 11]] 
```

### Correct results
My program produced the correct results. Here is the complete output from the application. The buffer storing D is printed out before and after the kernel executes.
```
Platform: Intel(R) FPGA SDK for OpenCL(TM)
Using one out of 1 device(s)
device name=  EmulatorDevice : Emulated Device
Using AOCX: mykernel.aocx
Program successfully created
D before operation:
        0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
D after operation:
        11.000000 11.000000 11.000000 11.000000 11.000000 11.000000 11.000000 11.000000 11.000000 11.000000 11.000000 11.000000
```
## Main Hurdles

The biggest hurdle for me was to understand the build system and OpenCL development environment. The OpenCL host code is complex, but is relatively straightforward and was well-covered in class. The OpenCL device code is almost identical to CUDA C, which I'm familiar with.
Specifically, I had issues debugging where the host executable looks for the compiled kernel. I also struggled for a bit trying to find the `init_opencl.sh` command to tell `aoc` where to find static libraries.
 - I'm sure Zach covered this in his tutorial. I was out for that lecture, so it was a self-inflicted issue.
 
## Takeaways

The biggest takeaway that I got was learning how to write an OpenCL application from start to finish. I understand all steps of the process (writing kernel code, host code, compiling and linking) at a shallow level which will set me up on future projects.

## Suggestions

I don't have much to suggest. If anything, it would be nice to have a neater Makefile for the examples, but what's provided is more than enough.
 - If I come up with a better Makefile I'll put it in a pull request to the main repo.

## Code link 

[https://github.com/30Wedge/eece-6540-labs/tree/Lab1](https://github.com/30Wedge/eece-6540-labs/tree/Lab1)