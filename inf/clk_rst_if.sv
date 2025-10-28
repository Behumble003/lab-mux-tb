//***************************************************************************************************************
// Module to generate clock and reset
//***************************************************************************************************************
import uvm_tb_udf_pkg::*;

interface clk_rst_if (output logic clk, output logic rst);
// pragma attribute clk_rst_if partition_interface_xif

  //
  // Generate reset
  //
	task do_reset (integer reset_length); // pragma tbx xtf
		rst = 1;
		repeat (reset_length) @(posedge clk);
		rst = 0;
	endtask
	
  //
  // Generate clock
  //
	initial begin
		#1;
		clk = 1;
		rst = 0;
		forever begin
			#HALF_CLK clk = ~clk;
		end
	end

endinterface
