interface spi_inter(clk);
    input clk;
    logic MISO,MOSI,SS_n,rst_n;
    modport DUT (
    input MOSI,rst_n,SS_n,clk,
    output MISO
    );
endinterface