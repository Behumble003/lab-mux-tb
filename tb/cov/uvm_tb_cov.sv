//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This class provides coverage for the REQ transactions. 
// To view coverage data, use the command
//    vsim -viewcov <filename>.ucdb
//***************************************************************************************************************
class uvm_tb_cov #(type REQ = uvm_sequence_item) extends uvm_component;

   `uvm_component_param_utils(uvm_tb_cov #(REQ))

   string   my_name;
  
   typedef uvm_tb_ap_queue #(REQ) uvm_tb_ap_queue_t;
  
   addr_t    addr;
   data_t    data;
   trans_t   transaction;
   
   uvm_tb_ap_queue_t cov_queue;
  
   //
   // covergroup is a user-defined construct. It can be declared outside or inside a class declaration.
   // Declaring it inside a class makes the code easier to read.
   // Here we are interested in monitoring coverage of the address and transaction types for all tlm transactions.
   //
   covergroup uvm_tb_cov_grp;
      //
      // Declare coverpoint for address. Coverage is divided into bins where each bin represents a range 
      // of values that the address falls into.
      //
      addr_cov: coverpoint addr {
         bins region_0 = {[ADDR_REG0_START:ADDR_REG0_END]};
         bins region_1 = {[ADDR_REG1_START:ADDR_REG1_END]};
         bins region_2 = {[ADDR_REG2_START:ADDR_REG2_END]};
         bins region_3 = {[ADDR_REG3_START:ADDR_REG3_END]};
         bins region_4 = {[ADDR_REG4_START:ADDR_REG4_END]};
         bins region_5 = {[ADDR_REG5_START:ADDR_REG5_END]};
         bins out_of_range = default;
         option.at_least = 20;
      }
      //
      // Declare coverage point for transaction. The coverage is in the form of transition of transaction
      // among a combination of sequence of transaction type.
      //
      transaction_cov: coverpoint transaction {
         bins read_after_write = (WRITE_SINGLE => READ_SINGLE);
         bins write_after_write = (WRITE_SINGLE => WRITE_SINGLE);
         bins read_after_read = (READ_SINGLE => READ_SINGLE);
         bins other_transaction_cov = default sequence;
         option.at_least = 10;
      }
      cross_addr_trans: cross addr_cov, transaction_cov;
   endgroup
   
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      uvm_tb_cov_grp = new;  // can't do this in build
   endfunction
  
   //
   // BUILD phase
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
      forever @(cov_queue.trigger_e)
         begin
         pkt = cov_queue.get_next_tlm();
         addr = pkt.addr;
         transaction = pkt.transaction;
         uvm_tb_cov_grp.sample();
         end
   endtask
   
endclass
