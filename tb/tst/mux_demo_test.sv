//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class mux_demo_test extends mux_base_test;

	`uvm_component_utils(mux_demo_test)
	
	string	my_name;
	
  //virtual interface clk_rst_if clk_rst_vif;
  
  typedef mux_in_demo_seq #(mux_in_tlm,mux_in_tlm) mux_in_demo_seq_t;
  mux_in_demo_seq_t mux_in_demo_seq;
  
  //
  // NEW
  //
	function new(string name, uvm_component parent);
		super.new(name,parent);
		my_name = "mux_demo_test";
	endfunction
	
  //
  // BUILD phase
  // Create an instance of demo sequence
  //
	function void build_phase(uvm_phase phase);
    mux_cfg   test_cfg;
    string      demo_seq_name;
    mux_in_seq_cfg  mux_in_demo_seq_cfg_h;
    integer	cmd_num_write;
      
		super.build_phase(phase);
		
		demo_seq_name = "mux_in_demo_seq_name";
		mux_in_demo_seq = mux_in_demo_seq_t::type_id::create(demo_seq_name);
		
		//
		// Need to pass in the number of writes (num_write) to the sequence.
		// First, need to get a handle to the TB_CONFIG 
		//
    //assert(uvm_resource_db #(mux_cfg)::read_by_name(get_full_name(),"TB_CONFIG",test_cfg));
    if (!uvm_config_db#(mux_cfg)::get(this,"","TB_CONFIG", test_cfg))
      `uvm_error("get_config_db error","mux_base_test")
  
    //
    // Optionally set up test verbosity configuration
    //
    test_cfg.verbosity_control_arr["monitor"] = IS_ENABLE;
    test_cfg.verbosity_control_arr["driver"] = IS_ENABLE;
    test_cfg.verbosity_control_arr["uvm_top"] = IS_ENABLE;
  
    //
    // Next, create a sequence config and assign the num_write in the sequence config to
    // the desired value. Then save the sequence config in the sequence config array in
    // the TB_CONFIG
    //
    mux_in_demo_seq_cfg_h = mux_in_seq_cfg::type_id::create("mux_in_demo_sequence_cfg");
    assert(mux_in_demo_seq_cfg_h.randomize());
    if ($value$plusargs("NUM_WRITE=%d",cmd_num_write))
    	mux_in_demo_seq_cfg_h.num_write = cmd_num_write;    
    else
    	mux_in_demo_seq_cfg_h.num_write = 4;    
    test_cfg.mux_in_seq_cfg_arr[demo_seq_name] = mux_in_demo_seq_cfg_h;
  
	endfunction
  
  //
  // RUN phase
  //
	task run_phase(uvm_phase phase);

    uvm_test_done.set_drain_time(this,DRAIN_TIME);
    phase.raise_objection(this,"Objection raised by mux_demo_test");
    
    //Todo: Start the mux_in_demo_seq
    // Note that the path to the sequencer can be determined by
    // - the environment instance
    // - the mux_in_agent instance
    // - the sequencer instance in the agent
    mux_in_demo_seq.start(env_h.mux_in_agent_0.sequencer);

    phase.drop_objection(this,"Objection dropped by mux_demo_test");
	endtask
	
endclass
