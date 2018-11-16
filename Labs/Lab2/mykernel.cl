/*
 * Calculates pi with the Gregory-Leibniz series on an OpenCL device
 *
 * Adapted from the Map-reduce example.
 *
 *
 * - Andy MacGregor
 *
 */

__kernel void pi_calculate(
    unsigned num_terms, 
    __local float* temp_result,
    __global float* global_result) {


  /*
Assumptions: 
    Guarantee that temp_result is the same length as the work_group size
    Guarantee that global_result is the same length as the number of work groups*

    pi_4 is the sum of both elements of global_results 
  */
 
   /* initialize local data */
  temp_result[get_local_id(0)] = 0;

   /* Make sure previous processing has completed */
   barrier(CLK_LOCAL_MEM_FENCE);

   // each group in the y dimension does work on [work_group_size] terms
   int iter_target = num_terms / get_num_groups(1);
   int iter_increment = get_local_size(0);
   int tid = get_local_id(0);

   int y_val = get_group_id(0); //only calculate this once

   for(int i = tid; i<iter_target; i+= iter_increment) {

      float d = ((i * 4 + 1) + 2 * y_val) * (y_val * (-2) + 1);

      //no barrier needed, since each work item can only access one local element
      temp_result[tid] += 1/d;
   }

   /* Make sure local processing has completed */
   barrier(CLK_LOCAL_MEM_FENCE);

   /* Perform CUDA-style reduction sum*/
   for(int i = get_local_size(0)/2; i >0; i >>= 1) 
   {
       if(tid < i) 
       {
            temp_result[tid] += temp_result[tid + i];
       }
       barrier(CLK_LOCAL_MEM_FENCE);
   }
   
   //copy reduced output to global output
   if(tid == 0)
        global_result[y_val] = temp_result[0]; 

}
