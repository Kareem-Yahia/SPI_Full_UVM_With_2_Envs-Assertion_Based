package ram_cover_collector;
		import uvm_pkg::*;
	import ram_seq_item::*;
	import ram_seq_item::*;
`include "uvm_macros.svh";

class ram_cover_collector extends uvm_component;
`uvm_component_utils(ram_cover_collector)
uvm_analysis_export #(ram_seq_item) cov_export;
uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
ram_seq_item seq_item_cov;
covergroup cg;
        din_cp: coverpoint seq_item_cov.din;
        din_trans_cp: coverpoint seq_item_cov.din[9:8]{
        bins bin_1= (2'b01 => 2'b01 =>2'b11 ); // transtions from all cases of read after write
        bins bin_2=(2'b01 => 2'b11 => 2'b10 ); // transtions from all cases of read after write
        bins bin_3= (2'b10 => 2'b00 =>2'b01 ); // transtions from all cases of write after read
                }
        rx_valid_cp: coverpoint seq_item_cov.rx_valid{
        bins bin_0={0};
        bins bin_1={1};
        }
	
	rst_cp: coverpoint seq_item_cov.rst_n{
        bins bin_0={0};
        bins bin_1={1} ;
	}	

	cross_din_reset: cross din_cp,rst_cp{
	bins binn= binsof(din_cp) && binsof(rst_cp.bin_1);
	ignore_bins binnn=binsof(din_cp) && binsof(rst_cp.bin_0);
	}

    endgroup 

function new(string name="ram_cover_collector", uvm_component parent=null);
  super.new(name, parent);
  cg=new;
    endfunction 
    function void build_phase (uvm_phase phase);
    	super.build_phase(phase);
    	cov_fifo=new("cov_fifo",this);
    	cov_export=new("cov_export",this);
    endfunction   

    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
   
     cov_export.connect(cov_fifo.analysis_export);
    endfunction: connect_phase


    task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	forever begin
    		cov_fifo.get(seq_item_cov);
            cg.sample();
    	end
    endtask : run_phase
	endclass
endpackage