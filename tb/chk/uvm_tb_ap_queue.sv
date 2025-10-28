//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uvm_tb_ap_queue #(type REQ = uvm_sequence_item) extends uvm_subscriber #(REQ);

  `uvm_component_param_utils(uvm_tb_ap_queue #(REQ))
   
  string   my_name;
  
  REQ     q[$];
  event trigger_e;
  
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //
  // Return the size of the queue
  //
  function integer get_size;
  	return q.size();
  endfunction
  	
  //
  // Return false if queue is empty, otherwise return true
  //
  function bool_t has_data;
    if (q.size() == 0)
      has_data = IS_FALSE;
    else
      has_data = IS_TRUE;
  endfunction
  
  //
  // Return next item in the queue, null if queue is empty
  //
  function REQ get_next_tlm();
    if (q.size() == 0)
      get_next_tlm = null;
    else
      get_next_tlm = q.pop_back();
  endfunction
  
  //
  // Push new item into queue
  //
  function void write(input REQ t);
    q.push_front(t);
    ->trigger_e;
  endfunction
   
endclass
