package SPI_seq_item_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class SPI_seq_item extends uvm_sequence_item;
		`uvm_object_utils(SPI_seq_item)
		typedef enum {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} state_e;
		rand logic in1;
		rand logic in2;
		rand logic in3;
		rand logic serial_data [8];
		rand logic rst_n_in;
		rand logic wait_plz;
		bit read_address_flag=0;
		bit write_address_flag=0;
		//Original transaction
		logic SS_n,MOSI,MISO;
		logic MISO_Ex;	

		constraint constr1 {rst_n_in dist {0:=2,1:=90};}
		
		//we want to constraint that scenario read_data always comes after read_address
		constraint constr2 {
			if(read_address_flag==0)
				{in1,in2,in3} != 3'b111;
			else if(read_address_flag==1)
				{in1,in2,in3} != 3'b110;
		}

		//here we want to constraint that write data always comes after write address

		constraint constr3 {
			if(write_address_flag==0)
				{in1,in2,in3} != 3'b001;
			else if(write_address_flag==1)
				{in1,in2,in3} != 3'b000;
		}

		constraint constr4 {
			if(in1 && in2 && in3)
				wait_plz==1;
			else
				wait_plz==0;
		}

		constraint constr5 {in1 == in2;} //as 
		//control signal must be equal to the bit after it for ex 00 for write or 11 for read

		function void post_randomize();
			if(!rst_n_in)
				read_address_flag=0;
			else if(in1 && in2 && !in3)
				read_address_flag=1;
			else if(in1 && in2 && in3)
				read_address_flag=0;

			//for writing
			if(!rst_n_in)
				write_address_flag=0;
			else if(!in1 && !in2 && !in3)
				write_address_flag=1;
			else if(!in1 && !in2 && in3)
				write_address_flag=0;

		endfunction

	function new (string name ="SPI_seq_item");
		super.new(name);
	endfunction 

		function string convert2string();
			return $sformatf("%s rst_n=%b, MOSI=%b, SS_n=%b ,  MISO=%b ",super.convert2string(),rst_n_in,MOSI,SS_n,MISO);
		endfunction
		
		function string convert2string_stimulus ();
			return $sformatf("rst_n =%b, MOSI=%b,  SS_n=%b",rst_n_in,MOSI,SS_n);
		endfunction 

	endclass 
endpackage 