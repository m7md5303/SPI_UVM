typedef enum logic[2:0] {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA  } state;
module SPI_SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid, tx_data, tx_valid);
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO;
output reg rx_valid;
output reg [9:0] rx_data; 



state cs,ns;
reg rd_flag; // to check if READ_ADD state has been executed or not (high if executed)
reg [3:0] state_countout;
reg[3:0] MISO_CountOut; ///// Bug msh mafrood 23 bits 3shan aslan fel reset ana me5aleh be 7 fa hayst3ml 3 bits bas
wire counter_enable; // to count 10 clock cycles while recieving data
wire counter_done; // flag sent by the counter, high when 10 cycles are completed
reg MISO_CountEn; 
wire MISO_CountDone;


//state logic
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    cs<= IDLE;
   
  end
  else begin
    cs<=ns;
  end
end  


//next state logic
always@(*) begin
  case(cs)
  IDLE: begin 
    
    if(~SS_n) 
      ns=CHK_CMD;
    else 
      ns=IDLE;
  end

  CHK_CMD:
    if(~SS_n) begin
      if(MOSI && ~rd_flag) begin
         ns=READ_ADD;
         
        end
        else if(MOSI && rd_flag) begin
         ns=READ_DATA;
         
        end
        else if(~MOSI) begin
         ns=WRITE;
        end
    end
    else if(SS_n) begin
      ns=IDLE;
    end

  READ_DATA:
    if(SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=READ_DATA;
    end

  READ_ADD:
    if(SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=READ_ADD;
    end
    
  WRITE:
     if(SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=WRITE;
    end
default:begin//missing default state
  ns=IDLE;
end
    endcase
end
  
// output logic
always@ (posedge clk or negedge  rst_n) begin//was missing negedge...
if(!rst_n) begin
  rd_flag<=0;//was multiply driven through the always blocks along the design
end
  if(cs==IDLE) begin
    MISO<=0;//was missing
    rx_data<=0;
  end
  else begin
  if(counter_enable) begin
    rx_data<={MOSI,rx_data[9:1]};
  end
  
  if(cs==READ_ADD && counter_done) begin
    rd_flag<=1;
  end
  else if (cs==READ_DATA && counter_done && MISO_CountDone)begin
    rd_flag<=0;
  end
   
  if(MISO_CountEn&&(cs==READ_DATA)) begin
    MISO<= tx_data[MISO_CountOut];
  end
end
end

// counters logic
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    state_countout<=0;
    MISO_CountOut<=7; // counter_down, to send MSB firstly to master
  end
  else begin
    if(cs==IDLE)begin
      state_countout<=0;
      MISO_CountOut<=7;
      MISO_CountEn<=0;
    end
    else if(counter_enable) begin
      state_countout<=state_countout+1;
    end
    if(counter_done) begin
      state_countout<=0;
      MISO_CountOut<=7;  
    end
    if(counter_done&&cs==READ_DATA)begin
    MISO_CountEn<=1;
    end
    if(MISO_CountEn) begin
      MISO_CountOut<=MISO_CountOut-1;
    end
    if (MISO_CountDone) begin
      MISO_CountOut<=7;
      MISO_CountEn<=0;
    end
  end  
end

assign counter_enable=(cs != IDLE && cs!=CHK_CMD && ~counter_done && ~MISO_CountEn)?1:0;
assign counter_done = (state_countout==4'b1010)?1:0;
assign MISO_CountDone = (MISO_CountOut== 0)?1:0;
always @(posedge clk ) begin
  if(counter_done)begin
    rx_valid<=1;
  end
  else begin
    rx_valid<=0;
  end
end

property assertion1;
 @(posedge clk) disable iff (!rst_n) (cs != IDLE && cs!=CHK_CMD && ~counter_done && ~MISO_CountEn) |-> (counter_enable==1);

endproperty 

  property assertion2;
    @(posedge clk) disable iff (!rst_n)  ($rose(counter_done)) |=> (rx_valid);
  endproperty 
property assertion3;
  @(posedge clk) disable iff(rst_n) (!rst_n) |=> (cs==IDLE && MISO==0 && rd_flag==0);
endproperty

 
property assertion4;
  @(posedge clk) disable iff (!rst_n) (cs==IDLE) |=> (!rx_data);
endproperty 

  property assertion5;
    @(posedge clk) disable iff (!rst_n) ##1 (counter_enable) [*10] |=> ( counter_done);
    endproperty
property assertion6;
    @(posedge clk) disable iff (!rst_n) (counter_done)|=> ( rx_valid);
    endproperty

property assertion7;
  @(posedge clk) disable iff(!rst_n) (cs==CHK_CMD && MOSI==0 && SS_n==0) |->  (ns==WRITE);
endproperty

property assertion8;
  @(posedge clk) disable iff(!rst_n) (cs==CHK_CMD && MOSI==1 && rd_flag==0&& SS_n==0) |->  (ns==READ_ADD);
endproperty

property assertion9;
  @(posedge clk) disable iff(!rst_n) (cs==CHK_CMD && MOSI==1 && rd_flag==1&& SS_n==0) |->  (ns==READ_DATA);
endproperty 
assert property(assertion1) else $display("assertion1 fails");
 assert property(assertion2) else $display("assertion2 fails");
assert property(assertion3) else $display("assertion3 fails");
 assert property(assertion4) else $display("assertion4 fails");
assert property(assertion5) else $display("assertion5 fails");
assert property(assertion6) else $display("assertion6 fails");
assert property(assertion7) else $display("assertion7 fails");
assert property(assertion8) else $display("assertion8 fails");
assert property(assertion9) else $display("assertion9 fails");
cover property (assertion1) $display("assertion1 passes");
cover property (assertion2) $display("assertion2 passes");
cover property (assertion3) $display("assertion3 passes");
cover property (assertion4) $display("assertion4 passes");
cover property (assertion5) $display("assertion5 passes");
cover property (assertion6) $display("assertion6 passes");
cover property (assertion7) $display("assertion7 passes");
cover property (assertion8) $display("assertion8 passes");
cover property (assertion9) $display("assertion9 passes");
endmodule



