//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
// This is the base class for the driver. It is to be extended by an actual driver. Note that an actual driver
// can be overridden by the factory. The only element that is of use here is the handle to the global config
// object.
//***************************************************************************************************************
class mux_in_driver_base #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

   `uvm_component_param_utils(mux_in_driver_base #(REQ,RSP))

   string   my_name;  // local name to be used in place of get_name()
   
   mux_cfg     driver_cfg;
   integer       rsp_pkt_cnt;
   
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
         
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      rsp_pkt_cnt = 0;
   endfunction
   
   //
   // BUILD phase
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name(); 
      cov_port = new($psprintf("%s_cov_port",my_name),this);
      //Todo: instantiate cov_port here
      // Refer to mux_in_monitor for an example of how ref_port is instantiated
   endfunction
  
   //
   // CONNECT phase
   // 
   function void connect_phase(uvm_phase phase);
      uvm_object  tmp_obj;
      //
      // Getting a handle to the global config object in driver_cfg
      if( !uvm_config_db #(mux_cfg)::get(this,"","TB_CONFIG",driver_cfg) ) begin
         `uvm_error(my_name, "Could not retrieve mux_cfg");
      end
      if( !uvm_config_db #(mux_cfg)::get(this,"","TB_CONFIG",driver_cfg) ) begin // configuration object named "TB_CONFIG" of type mux_cfg and assign it to driver_cfg
         `uvm_error(my_name, "Could not retrieve mux_cfg");
      end
   endfunction
  
   //
   // START_OF_SIMULATION phase
   //
   function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      // Control verbosity
      if (driver_cfg.verbosity_control_arr["driver"] == IS_ENABLE)
         set_report_verbosity_level(UVM_MEDIUM + 1);
      else
         set_report_verbosity_level(UVM_MEDIUM - 1); 
   endfunction
   
endclass
