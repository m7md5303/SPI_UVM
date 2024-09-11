interface golden_inter_ref(clk);
    input logic clk;
    logic MISO_gold,MOSI_gold,SS_n_gold,rst_n_gold;
    modport GOLDEN (
    input MOSI_gold,SS_n_gold,rst_n_gold,clk,
    output MISO_gold
    );
endinterface