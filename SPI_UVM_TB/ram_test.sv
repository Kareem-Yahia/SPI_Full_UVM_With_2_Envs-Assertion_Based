package ram_test;
import pkg_env::*;
import uvm_pkg::*;
import ram_config::*;
import ram_sequences::*;
import ram_agent::*;
`include "uvm_macros.svh";
class ram_test extends uvm_test;
`uvm_component_utils(ram_test);
ram_env env;
ram_config conf;
ram_sequence_main main_seq;
ram_sequence_write write_seq;
ram_sequence_read read_seq;
ram_sequence_reset rst_seq;
ram_agent agt;
virtual ram_if ram_vif;
function new (string name = "ram_test",uvm_component parent =null);
	super.new(name,parent);
	
endfunction 

function void build_phase (uvm_phase phase);
	super.build_phase(phase);
	env=ram_env::type_id::create("env",this);
	conf=ram_config::type_id::create("conf",this);
	main_seq=ram_sequence_main::type_id::create("main_seq",this);
	write_seq=ram_sequence_write::type_id::create("write_seq",this);
	read_seq=ram_sequence_read::type_id::create("read_seq",this);
	rst_seq=ram_sequence_reset::type_id::create("rst_seq",this);
	 if (!uvm_config_db#(virtual ram_if)::get(this, "", "ram_if", conf.ram_vif))
        `uvm_fatal("build_phase", "from test Error can't get the inteface from the config. db!")
      uvm_config_db#(ram_config)::set(this, "*", "CFG", conf);
endfunction

task run_phase (uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	`uvm_info("run_phase","reset assert",UVM_LOW)
	rst_seq.start(env.agt.seq);
	`uvm_info("run_phase","reset deassert",UVM_LOW)
		`uvm_info("run_phase","write_only assert",UVM_LOW)
	write_seq.start(env.agt.seq);
	`uvm_info("run_phase","write_only deassert",UVM_LOW)
		`uvm_info("run_phase","read_only assert",UVM_LOW)
	read_seq.start(env.agt.seq);
	`uvm_info("run_phase","read_only deassert",UVM_LOW)
	`uvm_info("run_phase","main assert",UVM_LOW)
	main_seq.start(env.agt.seq);
	`uvm_info("run_phase","main deassert",UVM_LOW)

	phase.drop_objection(this);
endtask : run_phase
endclass
endpackage