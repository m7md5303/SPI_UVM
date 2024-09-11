module SPI_Wrapper(spi_inter.DUT spi_if);
logic MOSI, SS_n,clk,rst_n,MISO;


assign MOSI=spi_if.MOSI;
assign SS_n=spi_if.SS_n;
assign rst_n=spi_if.rst_n;
assign spi_if.MISO=MISO;
assign clk=spi_if.clk;

wire [9:0] rxdata;
wire [7:0] txdata;
wire rx_valid,tx_valid;

//instantiation of spi slave and ram
SPI_RAM #(256,8) R (rxdata, txdata, rx_valid, tx_valid , clk, rst_n);
SPI_SLAVE  S (MOSI,MISO,SS_n,clk,rst_n,rxdata,rx_valid, txdata, tx_valid);


property assertion1;
	@(posedge clk) disable iff(rst_n)  (!rst_n)|=> (MISO==0);
endproperty

property assertion2;
	@(posedge clk) disable iff(!rst_n)  (S.cs!=4)|->##3 (!(MISO));
endproperty


assert property(assertion1) else $display("%t:assertion1 fails",$time);
assert property(assertion2) else $display("%t:assertion2 fails",$time);


cover property (assertion1) $display("assertion1 passes");
cover property (assertion2) $display("assertion2 passes");
 
endmodule


