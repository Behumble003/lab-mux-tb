//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************

interface mux_out_if (input logic clk, rst);

	wire [1:0] chan; //defined in wire because it is driven by dut
	wire [7:0] out_data0;
	wire [7:0] out_data1;
	wire [7:0] out_data2;
	wire [7:0] out_data3;
	wire valid;

endinterface
