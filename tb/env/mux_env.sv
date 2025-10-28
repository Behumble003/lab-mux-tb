//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(mux_env #(REQ,RSP))
   
   string my_name;
   
   typedef mux_in_agent  #(REQ,RSP) mux_in_agent_t;
   mux_in_agent_t mux_in_agent_0;
   typedef mux_out_agent  #(REQ,RSP) mux_out_agent_t;
   mux_out_agent_t mux_out_agent_0;
   typedef mux_in_sb #(REQ) mux_in_sb_t;
   mux_in_sb_t    sb;
   typedef mux_in_cov #(REQ) mux_in_cov_t;
   mux_in_cov_t   cov;
   
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   //
   // BUILD phase
   // Create instances of agents, scoreboard and coverage
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name();
      mux_in_agent_0 = mux_in_agent_t::type_id::create("mux_in_agent_0",this); // Needed for P1
      mux_out_agent_0 = mux_out_agent_t::type_id::create("mux_out_agent_0",this); // Needed for P2
      sb = mux_in_sb_t::type_id::create("Scoreboard",this); // Needed for P2
      cov = mux_in_cov_t::type_id::create("Coverage",this); // Needed for P3
   endfunction
   
   //
   // CONNECT phase
   // Connect the agent to scoreboard and coverage
   //
   function void connect_phase(uvm_phase phase);
      // The uvm_subscriber has a built-in analysis_export to be connected to 
      // an analysis port
      mux_in_agent_0.ref_port.connect(sb.ref_queue.analysis_export); // Needed for P2
      mux_out_agent_0.act_port.connect(sb.act_queue.analysis_export); // Needed for P2
      mux_in_agent_0.cov_port.connect(cov.cov_queue.analysis_export); // Needed for P3
   endfunction
   
endclass
