# Lab3  Report
- Andy MacGregor

## Description

  The objective of this lab is to understand how to do profiling in OpenCL.
This was with an OpenCL bechmark published by Intel that is designed to test 
many different performance metrics. First, we read Intel's code, then compiled
and ran the benchmark on a server with an OpenCL-enabled FPGA card.
Select results are displayed and interpreted in this report.s

## Outcome Summary

The following sections describe how two different benchmark tests work and
discuss their output.

---


### Kernel Latency

The kernel latency test is performed by setting up an OpenCL program and creating
a kernel called `nop` with `clCreateKernel` that does nothing when launched. The host queues the nop  kernel 10000 times with `clEnqueueTask` to launch the kernel
with a single work item then waits for the queue to empty with `clFinish`.
The latency of a single kernel ("single kernel round trip time") is reported by
dividing the total time it takes to empty the queue by 10000, the number of kernels launched.

#### Console Output
```
*****************************************************************
********************  Kernel Latency   **************************
*****************************************************************

Creating kernel (nop)
  OpenCL Notification Callback: [Runtime Warning]: Too many 'event' objects in the host. This causes deterioration in runtime performance
Processed 10000 kernels in 239.7354 ms
Single kernel round trip time = 23.9735 us
Throughput = 41.7127 kernels/ms
Kernel execution is complete.
```

As can be seen, the overhead of launching one kernel is **23.97us**.

---

### Kernel-to-Memory Bandwidth

The kernel-to-memory bandwidth test is more complicated.
First, the opencl host extracts an xml file from the compiled kernel .aocx file
with listed specifications for the target FPGA. Then, it parses the xml file to 
report the size of each memory bank on the FPGA.

Then it incrementally finds the maximum buffer allocation size available on the device, by creating buffers of increasing size and testing if the buffer allocation
fails.

After, the host allocates an input and output vector of the maximum allowed
size on host.

Each of the following kernel functions are involved,
`mem_writestream`, `mem_readstream`, `mem_read_writestream`. Each function takes
a single buffer argument, and performs a single write to the buffer, read from the buffer, or read and write to the buffer resepctively.

For each kernel function, it is run with a read/write buffer pinned to each possible
memory bank (1-7) using the `CL_MEM_BANK_X_ALTERA` bits of memflags passed when `clCreateBuffer` is called.

The kernel is queued with `clEnqueueNDRangeKernel`, and the time between kernel
enqueue and completion is measured by timing the period from that initial enqueue
and the final `clFinish`. The device buffer is deallocated and the process is repeated.

The measured bandwidth for each kernel is calculated by dividing the number of bytes
transferred by the execution time of the kernel (ignoring kernel overhead). A summary 
of the bandwidth is given for each memory access type (r,w,r/w) and memory bank.

Next the host parses the board_spec xml file for information about the global
memory and *most importantly* finds the maximum listed bandwidth for a single
memory bank, then the host computes the bandwidth utilization as (measured_bandwidth/listed_bandwidth).

Something is wrong with this test since the board utilization is reported as 150%
because that's not possible. That would mean the average bandwidth used by the board
is 1.5x the maximum bandwidth for the board.

I don't understand the format of the generated board_spec.xml file, but I think
that either the listed max bandwidth is wrong, or the author of this benchmark
misunderstood the "Max Bandwidth" term (reported as 25600MB/s) as being for 
all memory interface where it really applies to a single memory bank.
In the second case, the board's *actual* memory bandwidth utilization would be
75% instead (25600 /19205).

Either way, the reported bandwidth for each memory operation can be useful
when estimating timing for future kernels.

#### Console Output

```
*****************************************************************
*****************  Kernel-to-Memory Bandwidth   *****************
*****************************************************************

clGetDeviceInfo CL_DEVICE_MAX_MEM_ALLOC_SIZE = 4293918720 bytes.
Available max buffer size = 4293918720 bytes.
Size of memory bank 1 = 0x80000000 B
Size of memory bank 2 = 0x80000000 B

Performing kernel transfers of 1023 MBs on the default global memory (address starting at 0) 
  Note: This test assumes that design was compiled with --no-interleaving 

Launching kernel mem_writestream ...
Launching kernel mem_readstream ...
Launching kernel mem_read_writestream ...

Summarizing bandwidth in MB/s/bank for banks 1 to 8
 18562  18570  18564  18565  18561  18565  18562  18563  mem_writestream
 18100  18101  18103  18113  18101  18099  18320  18102  mem_readstream
 20886  20866  20886  21227  20881  20877  20881  20855  mem_read_writestream

Name of the global memory type not found in the board_spec. 
Number Of Interfaces      :  2 
Max Bandwidth (all memory interfaces) :  25600 MB/s 
Max Bandwidth of 1 memory interface :  12800 MB/s 

It is assumed that all memory interfaces have equal widths. 

BOARD BANDWIDTH UTILIZATION = 150.04% 

  Kernel mem bandwidth assuming ideal memory: 37167 MB/s
              * If this is lower than your board's peak memory
              * bandwidth then your kernel's clock isn't fast enough
              * to saturate memory
              *   approx. fmax = 290

Kernel mem bandwidth assuming ideal memory is greater than board's peak memory bandwidth. Success.


KERNEL-TO-MEMORY BANDWIDTH = 19205 MB/s/bank
```

## Difficulties

I had one funny issue. In Lab 1, i had issues because I forgot to set CL_CONTEXT_EMULATOR_DEVICE_ALTERA=1 so I put it in my bashrc. To run this Lab on the FPGA,
this variable had to be unset. Running `export CL_CONTEXT_EMULATOR_DEVICE_ALTERA=0`
wasn't enough, the variable itself had to be actually unset with the bash command `unset CL_CONTEXT_EMULATOR_DEVICE_ALTERA`.


## Takeaways

I learned what `unset` does in Linux. I was expecting to see more OpenCL Events
for profiling. I suppose those might be more useful for profiling custom kernels
instead of measuring board performance, because the timer functions seemed to work well
enough for this application.


## Suggestions

None. It was an easier lab than before. I appreciated being able to read real OpenCL
code from an industry benchmark as opposed to a textbook example.