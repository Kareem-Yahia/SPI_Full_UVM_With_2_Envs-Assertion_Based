package SPI_cov_pkg;
	import uvm_pkg::*;
	import SPI_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class SPI_cov extends uvm_component;

    `uvm_component_utils(SPI_cov)
    uvm_analysis_export #(SPI_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo;
    SPI_seq_item seq_item_cov;

    covergroup cg_SPI;
            a:coverpoint seq_item_cov.in1 iff(seq_item_cov.rst_n_in){
                    bins bin0={0};
                    bins bin1={1};
                }
               b: coverpoint seq_item_cov.in2 iff(seq_item_cov.rst_n_in){
                    bins bin0={0};
                    bins bin1={1};
                }
               c: coverpoint seq_item_cov.in3 iff(seq_item_cov.rst_n_in){
                    bins bin0={0};
                    bins bin1={1};
                }
                
                d:coverpoint seq_item_cov.rst_n_in{
                    bins bin0={0};
                    bins bin1={1};
                }
                e:coverpoint seq_item_cov.wait_plz iff(seq_item_cov.rst_n_in){
                    bins bin0={0};
                    bins bin1={1};
                }

                //in cross coverage we want to know how many times we get into write scenario and read scenario

                cross_coverage: cross a,b,c iff(seq_item_cov.rst_n_in) {
                    bins bin_write_address=binsof(a.bin0) && binsof(b.bin0) && binsof(c.bin0);
                    bins bin_write_data=   binsof(a.bin0) && binsof(b.bin0) && binsof(c.bin1);
                    bins bin_read_address= binsof(a.bin1) && binsof(b.bin1) && binsof(c.bin0);
                    bins bin_read_data=    binsof(a.bin1) && binsof(b.bin1) && binsof(c.bin1);
                    option.cross_auto_bin_max=0;
                }

            endgroup


        function new(string name="SPI_cov", uvm_component parent=null);
         super.new(name, parent);
         cg_SPI=new;
        endfunction 

        function void build_phase (uvm_phase phase);
        	super.build_phase(phase);
            seq_item_cov=SPI_seq_item::type_id::create("seq_item_cov",this);
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
            cg_SPI.sample();
    	end
    endtask : run_phase

	endclass
    
endpackage