//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_out_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(mux_out_monitor #(PKT))
  
  string   my_name;
  
  virtual interface mux_out_if       vif;
 
  uvm_analysis_port #(PKT)  act_port;

  mux_cfg   monitor_cfg;
 
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
  endfunction
  
  //
  // BUILD phase
  //
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_port = new($psprintf("%s_act_port",my_name),this);
  endfunction
  
  //
  // CONNECT phase
  //
  function void connect_phase(uvm_phase phase);
     
    assert(uvm_resource_db #(mux_cfg)::read_by_name(get_full_name(),"TB_CONFIG",monitor_cfg));
    if (monitor_cfg.inject_error == IS_TRUE)
      `uvm_info(my_name,"Error injection is true",UVM_NONE)
    else
      `uvm_info(my_name,"Error injection is false",UVM_NONE)
           
    //
    // Getting the interface handle
    //
    if( !uvm_config_db #(virtual mux_out_if)::get(this,"","mux_out_vif",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual mux_out_if");
    end
     
  endfunction
  
  //
  // START_OF_SIMULATION phase
  //
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    if (monitor_cfg.verbosity_control_arr["monitor"] == IS_ENABLE)
      set_report_verbosity_level(UVM_MEDIUM + 1);
    else
      set_report_verbosity_level(UVM_MEDIUM - 1);
  endfunction
  
  // Get byte data
  function logic [7:0] get_data(input logic [1:0] ch, input logic [7:0] d3, input logic [7:0] d2, input logic [7:0] d1, input logic [7:0] d0);
  	case (ch)
  		3: get_data = d3;
  		2: get_data = d2;
  		1: get_data = d1;
  		0: get_data = d0;
  	endcase
  endfunction
   
  //
  // Monitor to capture transactions at the output
  //
  virtual task monitoring;
    PKT     act_pkt;
    integer act_pkt_cnt;
    
    act_pkt_cnt = 0;
    forever @(posedge vif.clk) begin
      if (vif.rst==0 && vif.valid==1) begin
      	act_pkt_cnt++;
      	act_pkt = PKT::type_id::create($psprintf("act_pkt_id_%d",act_pkt_cnt));
      	act_pkt.data[31:24] = get_data(vif.chan,vif.out_data3,vif.out_data2,vif.out_data1,vif.out_data0);
      	act_pkt.chan = vif.chan;
      	@(posedge vif.clk);
       	act_pkt.data[23:16] = get_data(vif.chan,vif.out_data3,vif.out_data2,vif.out_data1,vif.out_data0);
      	@(posedge vif.clk);
       	act_pkt.data[15:08] = get_data(vif.chan,vif.out_data3,vif.out_data2,vif.out_data1,vif.out_data0);
      	@(posedge vif.clk);
       	act_pkt.data[07:00] = get_data(vif.chan,vif.out_data3,vif.out_data2,vif.out_data1,vif.out_data0);
				act_pkt.print(uvm_default_table_printer);
        //Todo: write the act_pkt to the act_port
        act_port.write(act_pkt);
      	`uvm_info(my_name,$sformatf("Monitor: Detected outgoing transaction: chan=%0d data=0x%0h",act_pkt.chan,act_pkt),UVM_MEDIUM)
      end
    end
    
  endtask
   
  task run_phase(uvm_phase phase);
    monitoring();
  endtask
   
endclass
