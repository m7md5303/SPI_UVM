package spi_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class spi_config extends uvm_object;
    `uvm_object_utils(spi_config)
    virtual spi_inter spi_vif_config;
    virtual golden_inter_ref gold_vif_config;

    function new (string name = "spi_config");
        super.new(name);
    endfunction
endclass
    
endpackage