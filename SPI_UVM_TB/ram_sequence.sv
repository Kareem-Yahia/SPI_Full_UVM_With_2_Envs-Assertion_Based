package ram_sequences ;
	import uvm_pkg::*;
`include "uvm_macros.svh";
import ram_seq_item::*;
class ram_sequence_reset extends uvm_sequence #(ram_seq_item);
`uvm_object_utils (ram_sequence_reset);
ram_seq_item seq_item;
function new (string name="ram_sequence_reset");
	super.new(name);
endfunction 
task body;
seq_item = ram_seq_item::type_id::create ("seq_item");
start_item (seq_item);

seq_item.rst_n=0;
seq_item.rx_valid=0;
seq_item.din=0;
finish_item(seq_item);

endtask
endclass


class ram_sequence_read extends uvm_sequence #(ram_seq_item);
`uvm_object_utils (ram_sequence_read);
ram_seq_item seq_item;
function new (string name="ram_sequence_read");
	super.new(name);
endfunction 
/*
task body;
	repeat(10000) begin;
seq_item = ram_seq_item::type_id::create ("seq_item");
start_item (seq_item);
seq_item.write_only.constraint_mode(0);
assert(seq_item.randomize());
finish_item(seq_item);
end
endtask
*/
endclass

class ram_sequence_write extends uvm_sequence #(ram_seq_item);
	
		`uvm_object_utils (ram_sequence_write);
		ram_seq_item seq_item;
		function new (string name="ram_sequence_write");
			super.new(name);
		endfunction
		/* 
		task body;
			repeat(10000) begin;
		seq_item = ram_seq_item::type_id::create ("seq_item");
		start_item (seq_item);
		seq_item.read_only.constraint_mode(0);
		assert(seq_item.randomize());
		finish_item(seq_item);
		end
		endtask
		endclass
		class ram_sequence_main extends uvm_sequence #(ram_seq_item);
		`uvm_object_utils (ram_sequence_main);
		ram_seq_item seq_item;
		function new (string name="ram_sequence_main");
			super.new(name);
		endfunction 
		task body;
			repeat(10000) begin;
		seq_item = ram_seq_item::type_id::create ("seq_item");
		start_item (seq_item);
		seq_item.write_only.constraint_mode(0);
		seq_item.read_only.constraint_mode(0);
		assert(seq_item.randomize());
		finish_item(seq_item);
		end
		endtask
		*/
	endclass



endpackage