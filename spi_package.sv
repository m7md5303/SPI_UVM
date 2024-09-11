package spi_pack;
typedef enum  logic [2:0] {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} state;
class spi_randomizing;
rand logic MOSI; //(inputs)
rand logic SS_n;
rand logic rst_n;
logic clk;
logic  MISO;	
 state cs=IDLE;
 rand logic [1:0] register=0;// 2 bit for states 
 logic[4:0] counter=0;
 logic [1:0] register_old=0;
 logic finish_frame=0;

constraint resetting { rst_n dist {0:=3,1:=97};
	};
 

covergroup cg @(posedge clk);
states_trans_cp: coverpoint cs	
{ bins transition_write=(IDLE=>CHK_CMD=>WRITE);
 bins transition_read_add=(IDLE=>CHK_CMD=>READ_ADD);
 bins transition_read_data=(IDLE=>CHK_CMD=>READ_DATA);
}
states_cp : coverpoint cs{
	bins READ_DATA_cs={READ_DATA};
}
MISO: coverpoint MISO{
	bins zeros={0};
	bins ones={1};
}
SS_N: coverpoint SS_n{
	bins zeros={0};
	bins ones={1};
}
cross MISO,SS_N{
	ignore_bins ss_n_high=binsof(SS_N)intersect{0};
}
cross MISO,states_cp;
RESET: coverpoint rst_n{
	bins zeros={0};
	bins ones={1};
}





endgroup : cg

    function new();
			cg =new();
		endfunction


  endclass          




	
endpackage 