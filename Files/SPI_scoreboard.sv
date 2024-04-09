package SPI_scoreboard_pkg;

	import SPI_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class SPI_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(SPI_scoreboard)

		uvm_analysis_export #(SPI_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(SPI_seq_item) sb_fifo;
		SPI_seq_item seq_item_sb;
		int error_count=0;
		int correct_count=0;

			function new(string name="SPI_scoreboard" , uvm_component parent=null);
				super.new(name,parent);
			endfunction

			function void build_phase(uvm_phase phase);
				super.build_phase(phase);
				sb_export=new("sb_export",this);
				sb_fifo=new("sb_fifo",this);

			endfunction

			function void connect_phase(uvm_phase phase);
				super.connect_phase(phase);
				sb_export.connect(sb_fifo.analysis_export);
			endfunction

			task check_result();
				if(seq_item_sb.MISO != seq_item_sb.MISO_Ex) begin
					`uvm_error("run_phase",$sformatf("fail in MISO dut:%s but MISO_Ex= %0b",seq_item_sb.convert2string(),seq_item_sb.MISO_Ex));
					error_count ++;
				end
				else begin
					`uvm_info("run_phase",$sformatf("Done in MISO dut:%s but MISO_Ex= %0b",seq_item_sb.convert2string(),seq_item_sb.MISO_Ex),UVM_MEDIUM);
					correct_count++;
				end
			endtask

			task run_phase(uvm_phase phase);
				super.run_phase(phase);
				forever begin
					sb_fifo.get(seq_item_sb);
					check_result();
				end
			endtask

			function void report_phase(uvm_phase phase);
				super.report_phase(phase);
				`uvm_info("run_phase",$sformatf("totall successgul transaction=%d",correct_count),UVM_MEDIUM)
				`uvm_info("run_phase",$sformatf("totall error transaction=%d",error_count),UVM_MEDIUM)
			endfunction

	endclass

endpackage 