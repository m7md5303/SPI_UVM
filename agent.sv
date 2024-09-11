package spi_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_sequencer_pkg::*;
import spi_driver_pkg::*;
import spi_monitor_Pkg::*;
import spi_config_pkg::*;
import spi_sequence_item_pkg::*;
class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)
    spi_sequencer sqr;
    spi_driver drv;
    spi_monitor mon;
    spi_config spi_cfg;

    uvm_analysis_port #(spi_sequence_item) agt_ap;

    function new(string name = "spi_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        spi_cfg=spi_config::type_id::create("spi_cfg",this);
        if(!uvm_config_db #(spi_config)::get(this , "" , "CFG" , spi_cfg))
        `uvm_fatal("build_phase" , "Unable to get configuration object in agent component")
        //
        sqr = spi_sequencer::type_id::create("sqr",this);
        drv = spi_driver::type_id::create("drv",this);
        mon = spi_monitor::type_id::create("mon",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
        mon.mon_ap.connect(agt_ap);
        drv.spi_vif_driver=spi_cfg.spi_vif_config;
        drv.gold_vif_driver=spi_cfg.gold_vif_config;
        //
        mon.spi_vif_monitor=spi_cfg.spi_vif_config;
        mon.gold_vif_monitor=spi_cfg.gold_vif_config;
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass
    
endpackage