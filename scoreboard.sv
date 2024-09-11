package spi_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_sequence_item_pkg::*;
import spi_config_pkg::*;
class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)
    uvm_analysis_export #(spi_sequence_item) sb_export;
    uvm_tlm_analysis_fifo #(spi_sequence_item) sb_fifo;
    // spi_config spi_cfg_sb;
    virtual golden_inter_ref gold_vif_sb;
    spi_sequence_item seq_item_sb;
    logic MISO_ref;
    int error_count=0,correct_count=0;
    logic valid;
    function new(string name="spi_scoreboard",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // spi_cfg_sb=spi_config::type_id::create("spi_cfg_sb",this);
    
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    //    if(!uvm_config_db #(logic)::get(this,"","GOLDEN_IF_MISO",MISO_ref))
    //     `uvm_fatal("build_phase","SCOREBOARD - Unable to get the virtual golden interface of the SPI from the uvm_config_db")
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction
    
     
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
           sb_fifo.get(seq_item_sb);
            if(seq_item_sb.MISO===gold_vif_sb.MISO_gold)begin
                correct_count++;
               `uvm_info("run_phase",$sformatf("Correct MISO: %s",seq_item_sb.convert2string()),UVM_HIGH) 
            end
            else begin
                error_count++;
                `uvm_error("run_phase",$sformatf("Comparison failed, Transacction received by the DUT is %s while the reference is %0b",seq_item_sb.convert2string(),gold_vif_sb.MISO_gold));
            end
        end
    endtask
   
    




    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transactions: %0d",error_count),UVM_MEDIUM);
    endfunction
endclass    
endpackage