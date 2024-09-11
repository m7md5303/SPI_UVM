package spi_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class spi_sequence_item extends uvm_sequence_item;
`uvm_object_utils(spi_sequence_item)
rand logic rst_n,MOSI,SS_n;
logic MISO,MISO_ref;
 function new(string name = "spi_sequence_item");
  super.new(name);
 endfunction
 function string convert2string();
  return $sformatf("%s rst_n = %0b , SS_n = %0b , MOSI = %0b , MISO = %0b",super.convert2string(),rst_n,SS_n,MOSI,MISO);
 endfunction

   constraint resetting { rst_n dist {0:=3,1:=97};
	}
   
endclass

  



endpackage