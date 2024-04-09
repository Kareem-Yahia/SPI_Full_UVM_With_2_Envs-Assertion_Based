package SPI_test_pkg;
	import SPI_config_obj_pkg::*;
	import SPI_sequence_pkg::*;
	import SPI_env_pkg::*;
	import pkg_env::*;
	import uvm_pkg::*;
	import ram_config::*;
	`include "uvm_macros.svh"
	
	class SPI_test extends uvm_test;
		`uvm_component_utils(SPI_test)

		SPI_env env;
		ram_env env_ram;
		SPI_config_obj SPI_config_obj_test;
		ram_config ram_config_test;
		SPI_sequence_reset seq_reset;
		SPI_sequence_main seq_main;

		function new(string name="SPI_test" , uvm_component parent=null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env=SPI_env::type_id::create("env",this);
			SPI_config_obj_test=SPI_config_obj::type_id::create("SPI_config_obj_test",this);
			seq_reset=SPI_sequence_reset::type_id::create("seq_reset",this);
			seq_main=SPI_sequence_main::type_id::create("seq_main",this);
			env_ram=ram_env::type_id::create("env_ram",this);
			ram_config_test=ram_config::type_id::create("ram_config_test",this);

			if(!uvm_config_db#(virtual SPI_if)::get(this, "", "SPIif",SPI_config_obj_test.SPI_vif ))
				`uvm_info("build_phase","Test cann't get interface",UVM_MEDIUM)

			if(!uvm_config_db#(virtual ram_if)::get(this, "", "ramif",ram_config_test.ram_vif ))
				`uvm_info("build_phase","Test cann't get interface_raaaam",UVM_MEDIUM)

			uvm_config_db#(SPI_config_obj)::set(this, "*", "CFG", SPI_config_obj_test);
			uvm_config_db#(ram_config)::set(this, "*", "CFG",ram_config_test );
			ram_config_test.active=UVM_PASSIVE;
			SPI_config_obj_test.active=UVM_ACTIVE;



		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			seq_reset.start(env.agent.sequencer);
			seq_main.start(env.agent.sequencer);
			`uvm_info("run_phase","welcome to uvm ",UVM_MEDIUM)
			phase.drop_objection(this);
		endtask

	endclass
endpackage