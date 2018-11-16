# Lab2  Report
- Andy MacGregor

## Description

The objective of this lab is to get comfortable with using the OpenCL memory hierarchy with barriers. This is demonstrated by approximating pi with the Gregory-Leibniz series. The kernel to perform this calculation essentially performs a map-reduce on the elements in the series to compute the sum in parallel.

## Outcome Summary

I set my program to sum the first 1000 series of the series. I use 2 work groups with 16 work-items each to calculate and sum the elements. This method calculates pi to be **3.14093** which is close enough to be within 2 decimal places.

The following shows the terminal output from my program.
```
hc_user7@acanets-PowerEdge-R730:~/HeteroWork/eece-6540-labs/Labs/Lab2: make
unset AOCL_BOARD_PACKAGE_ROOT
aoc -march=emulator mykernel.cl -o bin/mykernel.aocx

hc_user7@acanets-PowerEdge-R730:~/HeteroWork/eece-6540-labs/Labs/Lab2: cd bin/

hc_user7@acanets-PowerEdge-R730:~/HeteroWork/eece-6540-labs/Labs/Lab2/bin: ../main
Platform: Intel(R) FPGA SDK for OpenCL(TM)
Using one out of 1 device(s)
device name=  EmulatorDevice : Emulated Device
num_comp_units=1
global_size=32, local_size=16
Using AOCX: mykernel.aocx

Results:
        pi/4 = 0.785273, pi = 3.141093

hc_user7@acanets-PowerEdge-R730:~/HeteroWork/eece-6540-labs/Labs/Lab2/bin:
```

## Difficulties

I had some trouble correctly calculating the right sum-element for each work element at first. Because I couldn't single-step the kernel, I calculated them by hand until I got the formula right. Asside from that, it was smooth sailing.

## Takeaways
Local memory has to be allocated with a kernel parameter before launching the kernel. It is important to use a barrier between any two accesses to shared memory locations by multiple work items in a work group.

## Suggestions
*None*

## Final Source
[https://github.com/30Wedge/eece-6540-labs/tree/Lab2](https://github.com/30Wedge/eece-6540-labs/tree/Lab2)