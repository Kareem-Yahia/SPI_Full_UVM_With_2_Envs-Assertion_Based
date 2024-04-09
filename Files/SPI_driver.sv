package SPI_driver_pkg;

  import uvm_pkg::*;
  import SPI_config_obj_pkg::*;
  import SPI_seq_item_pkg::*; 
  `include "uvm_macros.svh"

  class SPI_driver extends uvm_driver #(SPI_seq_item);
          `uvm_component_utils(SPI_driver)
          SPI_seq_item stim_seq_item;
          virtual SPI_if SPIvif_driver;
          function new(string name="SPI_driver", uvm_component parent=null);
            super.new(name, parent);
          endfunction: new
          task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
            stim_seq_item=SPI_seq_item::type_id::create("stim_seq_item");
            seq_item_port.get_next_item(stim_seq_item);
            SPIvif_driver.MOSI=stim_seq_item.MOSI;
            SPIvif_driver.SS_n=stim_seq_item.SS_n;
            SPIvif_driver.rst_n_in=stim_seq_item.rst_n_in;

            //for coverage we will sample internal signals
            SPIvif_driver.in1=stim_seq_item.in1;
            SPIvif_driver.in2=stim_seq_item.in2;
            SPIvif_driver.in3=stim_seq_item.in3;
            SPIvif_driver.wait_plz=stim_seq_item.wait_plz;
            ///////////////////////////////////////////////
            @(negedge SPIvif_driver.clk);
            seq_item_port.item_done();
             `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH)
            end      
      endtask     
  endclass
  
endpackage