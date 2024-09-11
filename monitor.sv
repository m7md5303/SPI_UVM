package spi_monitor_Pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_sequence_item_pkg::*;
class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)
    virtual spi_inter spi_vif_monitor;
    virtual golden_inter_ref gold_vif_monitor;
    spi_sequence_item rsp_seq_item;
    uvm_analysis_port #(spi_sequence_item) mon_ap;


    function new(string name = "spi_monitor", uvm_component parent=null);
     super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap",this);
    endfunction : build_phase
    

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rsp_seq_item = spi_sequence_item::type_id::create("rsp_seq_item");
            @(negedge spi_vif_monitor.clk);
            //
            rsp_seq_item.MOSI=spi_vif_monitor.MOSI;
            //
            rsp_seq_item.rst_n=spi_vif_monitor.rst_n;
            //
            rsp_seq_item.SS_n=spi_vif_monitor.SS_n;
            //
            rsp_seq_item.MISO=spi_vif_monitor.MISO;
            //
            rsp_seq_item.MISO_ref=gold_vif_monitor.MISO_gold;
            //
            mon_ap.write(rsp_seq_item);
            `uvm_info("run_Phase",rsp_seq_item.convert2string(),UVM_HIGH)
        end
    endtask

endclass
    
endpackage