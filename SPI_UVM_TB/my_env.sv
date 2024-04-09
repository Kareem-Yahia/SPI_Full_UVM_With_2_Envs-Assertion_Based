package SPI_env_pkg;
	import SPI_scoreboard_pkg::*;
	import SPI_cov_pkg::*;
	import SPI_agent_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class SPI_env extends uvm_env;
		`uvm_component_utils(SPI_env)

		SPI_agent agent;
		SPI_scoreboard score_board;
		SPI_cov cov; 


		function new(string name="SPI_env" , uvm_component parent=null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agent=SPI_agent::type_id::create("agent",this);
			score_board=SPI_scoreboard::type_id::create("score_board",this);
			cov=SPI_cov::type_id::create("cov",this);

		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			agent.agt_ap.connect(score_board.sb_export);
			agent.agt_ap.connect(cov.cov_export);
		endfunction

	endclass


endpackage