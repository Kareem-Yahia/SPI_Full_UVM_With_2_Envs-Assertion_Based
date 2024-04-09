package SPI_monitor_pkg;
		import SPI_seq_item_pkg::*;
		import SPI_config_obj_pkg::*;
		import uvm_pkg::*;
		`include "uvm_macros.svh"

		class SPI_monitor extends uvm_monitor;
			`uvm_component_utils(SPI_monitor)
			virtual SPI_if SPIvif_monitor;
			SPI_seq_item my_seq_item;
			uvm_analysis_port #(SPI_seq_item) mon_ap;

			function new(string name="SPI_monitor" , uvm_component parent=null);
				super.new(name,parent);
			endfunction

			function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap=new("mon_ap",this);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				my_seq_item=SPI_seq_item::type_id::create("my_seq_item",this);
				@(negedge SPIvif_monitor.clk);
				my_seq_item.MOSI=SPIvif_monitor.MOSI;
				my_seq_item.MISO=SPIvif_monitor.MISO;
				my_seq_item.MISO_Ex=SPIvif_monitor.MISO_Ex;
				my_seq_item.SS_n=SPIvif_monitor.SS_n;
				my_seq_item.rst_n_in=SPIvif_monitor.rst_n_in;

				//for coverage we will sample internal signals
				my_seq_item.in1=SPIvif_monitor.in1;
				my_seq_item.in2=SPIvif_monitor.in2;
				my_seq_item.in3=SPIvif_monitor.in3;
				my_seq_item.wait_plz=SPIvif_monitor.wait_plz;
				///////////////////////////////////////////////

				mon_ap.write(my_seq_item);
				`uvm_info("run_phase",my_seq_item.convert2string(),UVM_HIGH)
			end
		endtask
		endclass

endpackage