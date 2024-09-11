import spi_pack::*;

module spi_tb();
logic MOSI,SS_n,clk,rst_n;
//logic [7:0] tx_data;
logic  MISO_dut1;
logic MISO_dut2;
//logic rx_valid;
//logic [9:0] rx_data;
parameter IDLE=3'b000;
parameter READ_DATA=3'b100;
parameter READ_ADD=3'b011;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
integer correct_counter=0;
integer error_counter=0;
logic [2:0] mosi_seq;
	spi_randomizing x;
	SPI_Wrapper dut1(MISO_dut1, MOSI,SS_n,rst_n,clk);
	topmod dut2 (rst_n,clk,SS_n,MISO_dut2,MOSI);
initial begin
    clk = 0;
    forever
      #10 clk = ~clk;
  end
always@(*)begin
	x.clk=clk;
end
  initial begin
  	x=new;
	repeat(20)begin
	assert(x.randomize());
  		SS_n=x.SS_n;
  		MOSI=x.MOSI;
		x.cs=dut1.S.cs;
  	resetting;
	end
	x.SS_n.rand_mode(0);



repeat(10000)begin
	SS_n=0;
	assert(x.randomize());
	MOSI=x.MOSI;
  @(negedge clk);
  x.cs=dut1.S.cs;
  if(!SS_n)begin
  	for(int i=0;i<3;i++)begin
  		mosi_seq[i]=MOSI;
  		 x.cs=dut1.S.cs;
assert(x.randomize());
  		MOSI=x.MOSI;
        @(negedge clk);
  	end
x.cs=dut1.S.cs;
if(mosi_seq==3'b111)begin
	repeat(18)begin
			assert(x.randomize());
			MOSI=x.MOSI;
			x.MISO=MISO_dut1;
  @(negedge clk);
  check_result;
  x.cs=dut1.S.cs;
	end
	x.cs=dut1.S.cs;
end
else begin
if(mosi_seq==3'b000 || mosi_seq==3'b001 || mosi_seq==3'b110)begin
repeat(10)begin
	assert(x.randomize());
			MOSI=x.MOSI;
			x.MISO=MISO_dut1;
  @(negedge clk);
  check_result;
  x.cs=dut1.S.cs;
end
x.cs=dut1.S.cs;
end
end
end
SS_n=1'b1;@(negedge clk);x.cs=dut1.S.cs;
  end
  x.SS_n.rand_mode(1);
repeat(500)begin
	assert(x.randomize());
	SS_n=x.SS_n;
	MOSI=x.MOSI;
	rst_n=x.rst_n;
	x.cs=dut1.S.cs;
end
SS_n=1;
rst_n=0;
repeat(5)@(negedge clk);
SS_n=1;
rst_n=1;
repeat(5)@(negedge clk);
SS_n=0;
#1;
rst_n=0;
@(negedge clk);
  $display("error counter=%0d",error_counter);
	$display("correct counter=%0d",correct_counter);
	#2 $stop;
  end






  task check_result;
	if(MISO_dut1!==MISO_dut2)  begin
		$display("%t:error in comparing MOSI",$time);
		error_counter++;
	end
	else correct_counter++;
	// if (tx_valid_dut1!=tx_valid_dut2)begin
	// 	$display("%t:error in comparing tx_valid",$time);
	// 	error_counter++;
	// end
	
endtask
task resetting;
	rst_n=0;
	@(negedge clk);
	if(MISO_dut1!==MISO_dut2)begin
		error_counter++;
		$display("error in reset functionality");
	end
	else correct_counter++;
	rst_n=1;
endtask 

endmodule 