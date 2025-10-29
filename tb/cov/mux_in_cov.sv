//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This class provides coverage for the REQ transactions. 
// To view coverage data, use the command
//    vsim -viewcov <filename>.ucdb
//***************************************************************************************************************
class mux_in_cov #(type REQ = uvm_sequence_item) extends uvm_component;

   `uvm_component_param_utils(mux_in_cov #(REQ))

   string   my_name;
  
   typedef uvm_tb_ap_queue #(REQ) uvm_tb_ap_queue_t;
  
   mux_in_data_t  data;
   mux_in_chan_t 	chan;
   
   uvm_tb_ap_queue_t cov_queue;
  
   //
   // covergroup is a user-defined construct. It can be declared outside or inside a class declaration.
   // Declaring it inside a class makes the code easier to read.
   // Here we are interested in monitoring coverage of the chan values
   //
   covergroup mux_in_cov_grp;
      //
      // Declare coverpoint for chan. Coverage is divided into bins where each bin represents one 
      // of each of the four possible values.
      //
      chan_cov: coverpoint chan {
         bins chan_3 = {3};
         bins chan_2 = {2};
         bins chan_1 = {1};
         bins chan_0 = {0};
         bins out_of_range = default;
      }
   endgroup
   
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      // Create an instance of covergroup
      mux_in_cov_grp = new;  // can't do this in build
   endfunction
  
   //
   // BUILD phase
   // Create an instance of cover queue
   //
   function void build;
      super.build();
      my_name = get_name();
      cov_queue = uvm_tb_ap_queue_t::type_id::create($psprintf("%s_cov_queue",my_name),this);
   endfunction
   
   //
   // RUN phase
   //
   task run;
      REQ pkt;
      // when a new coverage packet is pushed into the queue, an event is triggered.
      // This results in the sampling of the covergroup
      forever @(cov_queue.trigger_e)
         begin
         pkt = cov_queue.get_next_tlm();
         `uvm_info(my_name,$psprintf("chan=%d",pkt.chan),UVM_NONE)
         chan = pkt.chan;
         data = pkt.data;
         //Todone: Call the mux_in_cov_grp sample function
         mux_in_cov_grp.sample();
         end
   endtask
   
endclass
