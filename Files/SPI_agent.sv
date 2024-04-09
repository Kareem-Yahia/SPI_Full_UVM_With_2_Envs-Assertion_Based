package SPI_agent_pkg;
	import SPI_seq_item_pkg::*;
	import SPI_driver_pkg::*;
	import SPI_sequencer_pkg::*;
	import SPI_monitor_pkg::*;
	import SPI_config_obj_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class SPI_agent extends uvm_agent;
		`uvm_component_utils(SPI_agent)
		SPI_sequencer sequencer;
		SPI_driver driver;
		SPI_monitor monitor;
		SPI_config_obj SPI_config_obj_agent;
		uvm_analysis_port #(SPI_seq_item) agt_ap;



		function new(string name="SPI_agent",uvm_component parent=null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(SPI_config_obj)::get(this, "", "CFG",SPI_config_obj_agent))
			`uvm_info("build_phase","agent cann't get interface",UVM_MEDIUM)

		 if(SPI_config_obj_agent.active==UVM_ACTIVE) begin
			sequencer=SPI_sequencer::type_id::create("sequencer",this);
			driver=SPI_driver::type_id::create("driver",this);
		end
			monitor=SPI_monitor::type_id::create("monitor",this);


			agt_ap=new("agt_ap",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
					 if(SPI_config_obj_agent.active==UVM_ACTIVE) begin
			driver.SPIvif_driver=SPI_config_obj_agent.SPI_vif;
			driver.seq_item_port.connect(sequencer.seq_item_export);
					end

			monitor.SPIvif_monitor=SPI_config_obj_agent.SPI_vif;
			monitor.mon_ap.connect(agt_ap);
		endfunction

	endclass

endpackage