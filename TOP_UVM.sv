import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_test_pkg::*;

module top_uvm();
    logic clk;
    initial begin
        clk=0;
        forever begin
           #30; clk=~clk;
        end
    end
    spi_inter spi_if(clk);
    golden_inter_ref gold_if(clk);
    SPI_Wrapper DUT(spi_if);
    topmod Golden_ref(gold_if);
    initial begin
        uvm_config_db #(virtual spi_inter)::set(null,"uvm_test_top","SPI_IF",spi_if);
        uvm_config_db #(virtual golden_inter_ref)::set(null,"uvm_test_top","GOLDEN_IF",gold_if);
        run_test("spi_test");
    end
endmodule