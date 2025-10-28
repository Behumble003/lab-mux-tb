//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// The test package provides a test layer between the top module and the environment. More than
// one test can be included here.
//***************************************************************************************************************
package mux_test_pkg;

   import uvm_pkg::*;
   import uvm_tb_udf_pkg::*;
   import mux_env_pkg::*;
   import mux_in_tlm_pkg::*;
   import mux_in_seq_pkg::*;
   import mux_cfg_pkg::*;
   //import mux_in_agent_pkg::*;
   
   `include "uvm_macros.svh"  
   `include "mux_base_test.sv"
   //
   // All new tests must derive from base_test and must be listed here.
   // Each test is saved as one file
   //
   `include "mux_demo_test.sv"       // single sequence test
endpackage
