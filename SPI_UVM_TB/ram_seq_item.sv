package ram_seq_item;
	import uvm_pkg::*;
`include "uvm_macros.svh";
class ram_seq_item extends uvm_sequence_item;
	`uvm_object_utils(ram_seq_item)
	parameter ADDR_SIZE=8;
	rand bit rst_n, rx_valid;
	rand bit [9:0] din;
	bit tx_valid;
	bit[ADDR_SIZE-1:0]dout;

	logic [ADDR_SIZE-1:0] dout_ex;
  	logic tx_valid_ex;

	constraint c {
		rst_n dist {0:=10 , 1:=95};
		rx_valid dist {0:=20 , 1:=80};
	}

	constraint d {
		unique {din};
	}

	constraint write_only {
		din [9:8] inside {2'b00 , 2'b01};
	}

	constraint read_only {
		din [9:8] inside {2'b10 , 2'b11};
	}
	function new (string name ="ram_seq_item");
		super.new(name);
	endfunction 

	function string convert2string();
		return $sformatf("%s rst_n =%b, rx_valid=%b,  din=%b, tx_valid=%b,dataout=%b",super.convert2string(),rst_n,rx_valid,din,tx_valid,dout
);
		endfunction
		
		function string convert2string_stimulus ();
			return $sformatf("rst_n =%b, rx_valid=%b,  din=%b",rst_n,rx_valid,din);
		endfunction 

endclass : ram_seq_item

endpackage : ram_seq_item