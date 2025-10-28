//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_in_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(mux_in_monitor #(PKT))
  
  string   my_name;
  
  virtual interface mux_in_if       vif; // send the transaction to the interface
 
  uvm_analysis_port #(PKT)  ref_port; // send the reference transaction to the scoreboard

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
    ref_port = new($psprintf("%s_ref_port",my_name),this);
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
    if( !uvm_config_db #(virtual mux_in_if)::get(this,"","mux_in_vif",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual mux_in_if");
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
   
  //
  // This task monitors the input of the DUT. If it detects a valid incoming transaction
  // at the input, it forms a reference packet and sends out to the analysis port
  //
  task monitoring;
    PKT     ref_pkt;
    integer ref_pkt_cnt;
    
    ref_pkt_cnt = 0;
    forever @(posedge vif.clk) begin
      if (vif.rst==0 && vif.req==1) begin
      	ref_pkt_cnt++;
      	ref_pkt = PKT::type_id::create($psprintf("ref_pkt_id_%d",ref_pkt_cnt));
      	ref_pkt.data = vif.in_data;
      	ref_pkt.chan = vif.chan;
        //Todo: write ref_pkt to the ref_port
    
        ref_port.write(ref_pkt);
      	`uvm_info(my_name,$sformatf("Monitor: Detected incoming transaction: chan=%0d data=0x%0h",ref_pkt.chan,ref_pkt.data),UVM_MEDIUM)
      end
    end
    
  endtask
   
  //
  // RUN phase
  //
  task run_phase(uvm_phase phase);
    monitoring();
  endtask
   
endclass
