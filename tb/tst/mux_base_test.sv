//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// This is the base test layer. It instantiates the environment.
//***************************************************************************************************************
class mux_base_test extends uvm_test;

   `uvm_component_utils(mux_base_test)
   
   string         my_name = "mux_base_test";
  
   typedef mux_env #(mux_in_tlm,mux_in_tlm) env_t;
   env_t   env_h; 
   mux_cfg     default_cfg;
   mux_cfg     tb_cfg;

   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   //
   // BUILD phase
   // Create an instance of the environment
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //
      // Create TB_CONFIG and save in resource database
      //
      default_cfg = mux_cfg::type_id::create("default_cfg");
      assert(default_cfg.randomize());
      uvm_resource_db #(mux_cfg)::set("*","TB_CONFIG",default_cfg);

      env_h = env_t::type_id::create("mux_env",this);
   endfunction

   //
   // START OF SIMULATION phase
   //
   function void start_of_simulation_phase(uvm_phase phase);
    
      // Get config handle. Note that once the config handle is obtained, the internal fields can be modfied
      // using this handle. There is no need to save the config object back in the resource database.
      assert(uvm_resource_db #(mux_cfg)::read_by_name(get_full_name(),"TB_CONFIG",tb_cfg));
      //if (!uvm_config_db#(mux_cfg)::get(this,"","TB_CONFIG", tb_cfg))
      //  `uvm_error("get_config_db error","mux_base_test")
        
      // Set uvm_top verbosity level
      if (tb_cfg.verbosity_control_arr["uvm_top"] == IS_ENABLE)
         uvm_top.set_report_verbosity_level(UVM_MEDIUM + 1);
      else
         uvm_top.set_report_verbosity_level(UVM_MEDIUM - 1);
    
      set_global_timeout(GLB_TIMEOUT);
   endfunction
   
endclass
