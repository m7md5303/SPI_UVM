module topmod (golden_inter_ref.GOLDEN gold_if);

logic  MOSI,SS_n,rst_n,clk,MISO;

assign SS_n = gold_if.SS_n_gold;
assign rst_n= gold_if.rst_n_gold;
assign MOSI=gold_if.MOSI_gold;
assign clk=gold_if.clk;
assign gold_if.MISO_gold=MISO;

wire rx_valid,tx_valid;
wire [9:0] rx_data;
wire [7:0] tx_data;
rram RAM_INTERFACE(.din(rx_data),.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid),.dout(tx_data),.tx_valid(tx_valid));
SPI SPI_INTERFACE(.tx_valid(tx_valid),.tx_data(tx_data),.rx_valid(rx_valid),.rx_data(rx_data),.rst_n(rst_n),.clk(clk),.SS_n(SS_n),.MISO(MISO),.MOSI(MOSI));
endmodule 