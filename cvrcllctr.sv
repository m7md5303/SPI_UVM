package spi_coverage_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_sequence_item_pkg::*;
class spi_coverage_collector extends uvm_component;
    `uvm_component_utils(spi_coverage_collector)
    uvm_analysis_export #(spi_sequence_item) cov_export;
    uvm_tlm_analysis_fifo #(spi_sequence_item) cov_fifo;
    spi_sequence_item seq_item_cov;

    covergroup cg ;

MISO: coverpoint seq_item_cov.MISO{
	bins zeros={0};
	bins ones={1};
}
SS_N: coverpoint seq_item_cov.SS_n{
	bins zeros={0};
	bins ones={1};
}
cross MISO,SS_N{
	ignore_bins ss_n_high=binsof(SS_N)intersect{0};
}

RESET: coverpoint seq_item_cov.rst_n{
	bins zeros={0};
	bins ones={1};
}





endgroup : cg

function new(string name="spi_coverage_collector",uvm_component parent=null);
    super.new(name,parent);
    cg=new();
endfunction

 
 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export=new("cov_export",this);
    cov_fifo=new("cov_fifo",this);
 endfunction

 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
 endfunction


 task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item_cov);
        cg.sample();
    end
 endtask
endclass
    
endpackage