//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class mux_in_tlm extends uvm_sequence_item;

  `uvm_object_utils(mux_in_tlm)
  
   string   my_name;
   
   // Todo:
   // Refer tb/env/uvm_tb_udf_pkg.svh
   // Declare random variable data of type mux_in_data_t
   // Declare random variable chan of type mux_in_chan
   rand mux_in_data_t data;
   rand mux_in_chan_t chan;
			
   bit to_reset;
   
   //
   // NEW
   //
   function new(string name = "mux_in_tlm");
      super.new(name);
      my_name = name;
   endfunction
   
   //
   // This function is called when the following is called
   // dst.copy(src)
   //
   function void do_copy(uvm_object rhs);
      mux_in_tlm  der_type;
      super.do_copy(rhs);
      $cast(der_type,rhs);
      data = der_type.data;
      chan = der_type.chan;
   endfunction
   
   //
   // This function is called when the following is called
   // ref_obj.compare(act_obj)
   //
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      mux_in_tlm  der_type;
      do_compare = super.do_compare(rhs,comparer);
      $cast(der_type,rhs);
      do_compare &= comparer.compare_field_int("chan",chan,der_type.chan,MUX_IN_CHAN_WIDTH); //&= is AND
      do_compare &= comparer.compare_field_int("data",data,der_type.data,MUX_IN_DATA_WIDTH); 
   endfunction
   
   //
   // This function is used by the built-in comparator
   //
   function bit comp(mux_in_tlm obj);
      return ((this.chan == obj.chan) &&
         (this.data == obj.data));
   endfunction
  
   function string transaction2string(mux_in_chan_t ch);
      case (ch)
         3: return "CHAN 3";
         2: return "CHAN 2";
         1: return "CHAN 1";
         0: return "CHAN 0";
         default: return "UNKNOWN";
      endcase
   endfunction
   
   //
   // This function is called when the following is called
   // obj.print()
   //
   function void do_print(uvm_printer printer);
      printer.print_field("data",data,$bits(data));
      printer.print_field("chan",chan,$bits(chan));
   endfunction
   
   // This is needed for the built-in in-order comparator
   function string convert2string();
      convert2string = $psprintf("chan=%x data=%x",chan,data);
   endfunction
  
   //
   // Coonstraint block
   //
   constraint mux_in_c {
   	to_reset == 0;
  }
   
endclass
