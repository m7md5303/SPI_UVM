package spi_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_sequence_item_pkg::*;


class spi_driver extends uvm_driver #(spi_sequence_item);
 `uvm_component_utils(spi_driver)
 virtual spi_inter spi_vif_driver;
 virtual golden_inter_ref gold_vif_driver;
 spi_sequence_item stim_seq_item;

 function new(string name="spi_driver",uvm_component parent = null);
  super.new(name,parent);
 endfunction

 task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    stim_seq_item = spi_sequence_item::type_id::create("stim_seq_item");
    seq_item_port.get_next_item(stim_seq_item);
    //
    spi_vif_driver.MOSI=stim_seq_item.MOSI;
    gold_vif_driver.MOSI_gold=stim_seq_item.MOSI;
    //
    spi_vif_driver.SS_n=stim_seq_item.SS_n;
    gold_vif_driver.SS_n_gold=stim_seq_item.SS_n;
    //
    spi_vif_driver.rst_n=stim_seq_item.rst_n;
    gold_vif_driver.rst_n_gold=stim_seq_item.rst_n;
    //
    @(negedge spi_vif_driver.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase",stim_seq_item.convert2string(),UVM_HIGH)




  end


 endtask


endclass
    
endpackage