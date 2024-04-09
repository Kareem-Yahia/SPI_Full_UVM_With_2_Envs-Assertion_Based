package SPI_sequence_pkg ;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_seq_item_pkg::*;

	class SPI_sequence_reset extends uvm_sequence #(SPI_seq_item);
		`uvm_object_utils (SPI_sequence_reset);
		SPI_seq_item seq_item;

		function new (string name="SPI_sequence_reset");
			super.new(name);
		endfunction

		task body;
			seq_item = SPI_seq_item::type_id::create ("seq_item");
			start_item (seq_item);
			seq_item.in1=0;
			seq_item.in2=0;
			seq_item.in3=0;
			// seq_item.serial_data=0;
			seq_item.rst_n_in=0;
			seq_item.wait_plz=0;
			seq_item.SS_n=0;
			seq_item.MOSI=0;
			seq_item.MISO=0;
			finish_item(seq_item);
			endtask
		endclass

		class SPI_sequence_main extends uvm_sequence #(SPI_seq_item);

		`uvm_object_utils (SPI_sequence_main);
		SPI_seq_item seq_item;

		function new (string name="SPI_sequence_main");
			super.new(name);
		endfunction

		task body;
			seq_item = SPI_seq_item::type_id::create ("seq_item");

			repeat(10000) begin
			assert(seq_item.randomize());
			start_item (seq_item);
			seq_item.SS_n=0;
			finish_item(seq_item);

			start_item (seq_item);
			seq_item.MOSI=seq_item.in1;
			finish_item(seq_item);

			start_item (seq_item);
			seq_item.MOSI=seq_item.in2;
			finish_item(seq_item);

			start_item (seq_item);
			seq_item.MOSI=seq_item.in3;
			finish_item(seq_item);

			for(int i=0 ;i<8 ;i++) begin
			start_item (seq_item);
			seq_item.MOSI=seq_item.serial_data[i];
			 finish_item(seq_item);
				  end
			if(seq_item.wait_plz ==1 ) begin 
				repeat (8) begin
					start_item(seq_item);
					seq_item.MOSI=$random;
					finish_item(seq_item);
				end
			end
			start_item(seq_item);
			seq_item.SS_n=1;        // end of commun
			finish_item(seq_item);

			end

			//for fsm coverage clausure
			start_item(seq_item);
			seq_item.SS_n=1;        
			finish_item(seq_item);

			repeat(20) begin
				start_item(seq_item);
				finish_item(seq_item);
			end

			 start_item(seq_item);
			seq_item.SS_n=0;        
			finish_item(seq_item);

			start_item(seq_item);
			seq_item.SS_n=1;        
			finish_item(seq_item);
			///////////////////////////////////

		
		endtask
	endclass

endpackage