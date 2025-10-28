//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_in_seq_cfg extends uvm_object;

  `uvm_object_utils(mux_in_seq_cfg)
  
  string  my_name;
  uvm_table_printer printer;
  
  rand integer    drain_time;
  rand integer    num_write;
  
  //
  // NEW
  //
  function new(string name = "");
    super.new(name);
    printer = new;
  endfunction
  
  //
  // This function is called when the following code executes
  //   obj.print()
  //
  function void do_print(uvm_printer printer);
    printer.print_field("drain time",drain_time,$bits(drain_time));
  endfunction
  
  //
  // Constraint block
  //
  constraint default_config_c {
    drain_time == DRAIN_TIME;
  }
  
endclass
