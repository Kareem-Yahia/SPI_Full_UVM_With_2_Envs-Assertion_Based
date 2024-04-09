package ram_scoreboard;
	
	import uvm_pkg::*;
	import ram_seq_item::*;
	`include "uvm_macros.svh"

	class ram_scoreboard extends uvm_scoreboard;
			`uvm_component_utils(ram_scoreboard)
			uvm_analysis_export #(ram_seq_item) sb_export;
			uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
			ram_seq_item seq_item_sb;
			parameter MEM_DEPTH=256;
			parameter ADDER_SIZE=8;
			int error_count;
			int correct_count;

		function new(string name="ram_scoreboard", uvm_component parent=null);
		      super.new(name, parent);

		 endfunction: new

		  function void build_phase (uvm_phase phase);
		   super.build_phase(phase);
		   sb_export=new("sb_export",this);
		   sb_fifo=new("sb_fifo",this);

		    endfunction

		    function void connect_phase(uvm_phase phase);
		    	super.connect_phase(phase);
		    	sb_export.connect(sb_fifo.analysis_export);

		    endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				sb_fifo.get(seq_item_sb);
				if(seq_item_sb.dout!==seq_item_sb.dout_ex) begin
					`uvm_error("run_phase",$sformatf("fail in dout dut:%s but out= %0b \n",seq_item_sb.convert2string(),seq_item_sb.dout_ex))
					error_count++;
				end
				else if(seq_item_sb.tx_valid!==seq_item_sb.tx_valid_ex) begin
					`uvm_error("run_phase",$sformatf("fail in tx_valid dut:%s but out= %0b \n",seq_item_sb.convert2string(),seq_item_sb.tx_valid_ex))
					error_count++;
				end
				else begin
					`uvm_info("run_phase",$sformatf("Done in tx_valid dut:%s but out= %0b \n",seq_item_sb.convert2string(),seq_item_sb.tx_valid_ex),UVM_MEDIUM)
				correct_count++;
				end
			end
		endtask : run_phase

		function void report_phase (uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf("total successful : %0d",correct_count),UVM_MEDIUM);
			`uvm_info("report_phase",$sformatf("total failed : %0d",error_count),UVM_MEDIUM);
		endfunction  
	endclass
endpackage