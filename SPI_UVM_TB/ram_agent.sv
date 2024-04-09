package ram_agent;
  import uvm_pkg::*;
  import ram_sequencer::*;
  import ram_driver::*;
  import ram_monitor::*;
  import ram_config::*;
  import ram_seq_item::*;
`include "uvm_macros.svh";
  class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent);
    ram_config conf;
    ram_driver driver;
    ram_monitor monitor;
    ram_sequencer seq;
    uvm_analysis_port #(ram_seq_item) agt_ap;
function new (string name = "ram_agent",uvm_component parent=null);
  super.new(name,parent);
endfunction  
function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      conf=ram_config::type_id::create("conf",this);
      monitor=ram_monitor::type_id::create("monitor",this);

      if (!uvm_config_db#(ram_config)::get(this, "", "CFG", conf))
      `uvm_fatal("build_phase", "from driver Error can't get the inteface from the config. db!")

    if(conf.active==UVM_ACTIVE) begin
      driver=ram_driver::type_id::create("driver",this);
      seq=ram_sequencer::type_id::create("seq",this);
    end
      agt_ap=new("agt_ap",this);
   
    
    endfunction: build_phase

    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      monitor.ram_vif=conf.ram_vif;
       monitor.mon_ap.connect(agt_ap);

    if(conf.active==UVM_ACTIVE) begin
      driver.ram_vif=conf.ram_vif;
      driver.seq_item_port.connect(seq.seq_item_export);
    end
    endfunction: connect_phase



  endclass


endpackage