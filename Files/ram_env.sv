package pkg_env;
	import uvm_pkg::*;
	import ram_sequences::*;
	import ram_sequencer::*;
	import ram_driver::*;
	import ram_monitor::*;
	import ram_agent::*;
	import ram_scoreboard::*;
	import ram_cover_collector::*;
`include "uvm_macros.svh";
class ram_env extends uvm_env;
	`uvm_component_utils (ram_env);
	ram_agent agt;
	ram_scoreboard sb;
	ram_cover_collector cov;
	function new (string name ="ram_env",uvm_component parent=null);
		super.new(name,parent);
	endfunction  
	function void build_phase (uvm_phase phase);
		super.build_phase (phase);
		agt=ram_agent::type_id::create("agr",this);
		cov=ram_cover_collector::type_id::create("cov",this);
		sb=ram_scoreboard::type_id::create("sb",this);
	endfunction 
	function void connect_phase (uvm_phase phase);
		agt.agt_ap.connect(sb.sb_export);
		agt.agt_ap.connect(cov.cov_export);
	 endfunction  
endclass
	endpackage