//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class mux_in_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(mux_in_agent #(REQ,RSP))
   
   typedef mux_in_driver #(REQ,RSP) mux_in_driver_t;
   typedef mux_in_monitor #(REQ) mux_in_monitor_t;
   typedef uvm_sequencer #(REQ,RSP) mux_in_sequencer_t;
   
   string   my_name;
   
   mux_in_sequencer_t  sequencer;
   mux_in_driver_t      driver ;
   mux_in_monitor_t    monitor;
  
   uvm_analysis_port #(REQ) ref_port;  // This port is used to send reference data to the scoreboard
   uvm_analysis_port #(REQ) act_port;  // This port is used to send actual data to the scoreboard
  
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
  
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   //
   // BUILD phase
   // Create instances of sequencer, driver, and monitor
   // Create instances of analysis ports
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = mux_in_sequencer_t::type_id::create("mux_in_sequencer",this);
      driver = mux_in_driver_t::type_id::create("mux_in_driver",this);
      monitor = mux_in_monitor_t::type_id::create("mux_in_monitor",this);
      ref_port = new($psprintf("%s_ref_port",my_name),this);
      act_port = new($psprintf("%s_act_port",my_name),this);
      cov_port = new($psprintf("%s_cov_port",my_name),this);
   endfunction
   
   //
   // CONNECT phase
   // Connect ports and connect sequencer to driver
   //
   function void connect;
      monitor.ref_port.connect(ref_port);
      driver.cov_port.connect(cov_port);
      //
      // Connect the sequencer to the driver
      //
      driver.seq_item_port.connect(sequencer.seq_item_export);
      //Todo: perform the connection between the driver and the sequencer
   endfunction
   
endclass
