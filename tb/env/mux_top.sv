//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
//***************************************************************************************************************
import uvm_pkg::*;
import mux_test_pkg::*;

module top;
   
  wire clk;
  wire rst;
   
  //
  // Create interface instances here
  //
  clk_rst_if clk_rst_if0(.clk(clk),.rst(rst));
  mux_in_if mux_in_if0(.clk(clk),.rst(rst));
  mux_out_if mux_out_if0(.clk(clk),.rst(rst));
   
  //
  // Create DUT instance
  //
  dut dut0 (.in_req(mux_in_if0.req),
            .in_chan(mux_in_if0.chan),
            .in_data(mux_in_if0.in_data),
            .rst(rst),
            .clk(clk),
            .q_full(mux_in_if0.q_full),
            .out_chan(mux_out_if0.chan),
            .out_data0(mux_out_if0.out_data0),
            .out_data1(mux_out_if0.out_data1),
            .out_data2(mux_out_if0.out_data2),
            .out_data3(mux_out_if0.out_data3),
            .valid(mux_out_if0.valid)
            );

  initial begin
    //
    // Put the interface handles in the resource database
    //
    uvm_config_db #(virtual clk_rst_if)::set(null,"*","CLK_RST_VIF",clk_rst_if0);
    uvm_config_db #(virtual mux_in_if)::set(null,"*","mux_in_vif",mux_in_if0);
    uvm_config_db #(virtual mux_out_if)::set(null,"*","mux_out_vif",mux_out_if0);

    //
    // Run test
    //
    run_test();
  end

endmodule
