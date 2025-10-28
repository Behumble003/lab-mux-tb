//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_in_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP); //default type is uvm_sequence_item

  `uvm_object_param_utils(mux_in_demo_seq #(REQ,RSP))
  
  string my_name;
  
  integer drain_time = DRAIN_TIME;
  integer num_write = 10;
  
  mux_cfg     mux_cfg_h;   // testbench config object
  mux_in_seq_cfg     seq_cfg;  // sequence config object
   
  //
  // NEW
  //  
  function new(string name="");
    super.new(name);
  endfunction
   
  //
  // BODY task
  //
  task body;
    REQ req_pkt;
    RSP   rsp_pkt; 
    
    my_name = get_name();
    
    // Cannot do uvm_config_db here  
    assert(uvm_resource_db #(mux_cfg)::read_by_name(get_full_name(),"TB_CONFIG",mux_cfg_h));
    
    seq_cfg = mux_cfg_h.mux_in_seq_cfg_arr[my_name];
    
    if (seq_cfg != null) begin
      num_write = seq_cfg.num_write;
      drain_time = seq_cfg.drain_time;
    end
    else begin
    	`uvm_error(my_name,"Could not get a handle to the sequence config")
    end
    
    `uvm_info("mux_in_demo_seq: ",$psprintf("num_write = %d, drain_time=%d",num_write,drain_time),UVM_MEDIUM)
    
    for (int ii=0; ii<num_write; ii++) begin
      req_pkt = REQ::type_id::create($psprintf("req_pkt_id_%d",ii));
        // Randomize the request packet
        if (!req_pkt.randomize()) begin
          `uvm_error(my_name, $psprintf("Randomization failed for req_pkt %0d", ii))
        end
        // Make the first packet a reset packet
        if (ii == 0) begin
          req_pkt.to_reset = 1;
        end

        // Send the req_pkt to the driver
        start_item(req_pkt);
        finish_item(req_pkt);

        `uvm_info(my_name,$psprintf("Sending packet %0d chan=%x data=%x",ii,req_pkt.chan,req_pkt.data),UVM_NONE)
        // Wait for the response packet from the driver
        get_response(rsp_pkt);
        `uvm_info(my_name,$psprintf("Received reponse packet"),UVM_NONE)
    end
        
  endtask
   
endclass
