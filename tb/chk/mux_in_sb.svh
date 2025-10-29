//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_in_sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

   `uvm_component_param_utils(mux_in_sb #(REQ))
   
   typedef uvm_in_order_class_comparator #(REQ) comp_t; // Need this for the type_id::create call below
   typedef uvm_tb_ap_queue #(REQ) uvm_tb_ap_queue_t;
  
   string   my_name;
   
   comp_t comparer;
   uvm_analysis_port #(REQ) in_order_ref_port;
   uvm_analysis_port #(REQ) in_order_act_port;
   
   uvm_tb_ap_queue_t ref_queue; // Queue to store reference data
   uvm_tb_ap_queue_t act_queue; // Queue to store actual data
  
   mux_cfg   sb_cfg;
   
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = name;
   endfunction
   
   //
   // BUILD phase
   // Create instances of reference queue and actual queue
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      comparer = comp_t::type_id::create("comparer",this);
      in_order_ref_port = new("in_order_ref_port",this);
      in_order_act_port = new("in_order_act_port",this);
      ref_queue = uvm_tb_ap_queue_t::type_id::create($psprintf("%s_ref_queue",my_name),this);
      act_queue = uvm_tb_ap_queue_t::type_id::create($psprintf("%s_act_queue",my_name),this);
   endfunction
   
   //
   // CONNECT phase
   // Connect ports to queues
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // The comparer has two built-in export ports: before_export and after_export
      in_order_ref_port.connect(comparer.before_export);
      in_order_act_port.connect(comparer.after_export);

      //Todone: connect the in_order_act_port to the comparer's after_export
      assert(uvm_resource_db #(mux_cfg)::read_by_name(get_full_name(),"TB_CONFIG",sb_cfg));
   endfunction
  

  //
  // START_OF_SIMULATION phase
  //
  function void start_of_simulation_phase(uvm_phase phase);
    if (sb_cfg.verbosity_control_arr["scoreboard"] == IS_ENABLE)
      set_report_verbosity_level(UVM_MEDIUM + 1);
    else
      set_report_verbosity_level(UVM_MEDIUM - 1);
    // The comparer's default verbosity is warning, change it to error
		comparer.set_report_severity_override(UVM_WARNING,UVM_ERROR);
  endfunction
  
  //
  // CHECK phase
  //
  function void check_phase(uvm_phase phase);
  	integer qsize;
  	
    // Verify that at the end of simulation, the reference queue must be empty
  	qsize = ref_queue.get_size();
  	if (qsize > 0)
  		`uvm_warning(my_name,$psprintf("Reference queue has %0d un-verified transactions",qsize));
  endfunction

  //
  // RUN phase
  //
  task run_phase(uvm_phase phase);
    REQ   rref;
    REQ   aact;
    
    //
    forever @(act_queue.trigger_e)
       begin
         rref = ref_queue.get_next_tlm();
         aact = act_queue.get_next_tlm();
         // When the data is written to the comparer after_export, the comparer automatically
         // performs the comparison
         in_order_ref_port.write(rref);
         in_order_act_port.write(aact); // write to the comparer after_export

         //Todone: Write aact packet to the in_order_act_port
       end
    endtask
   
endclass

