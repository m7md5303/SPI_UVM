package spi_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_sequence_item_pkg::*;
    class spi_reset_sequence extends uvm_sequence #(spi_sequence_item);
        `uvm_object_utils (spi_reset_sequence)
        spi_sequence_item seq_item;

        function new(string name = "spi_reset_sequence");
            super.new(name);
        endfunction

        task body();
           seq_item = spi_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=0;
           seq_item.SS_n=1;
           seq_item.MOSI=0;
           finish_item(seq_item);
        endtask
    endclass

    class spi_MOSI_HIGH_sequence extends uvm_sequence #(spi_sequence_item);
         `uvm_object_utils (spi_MOSI_HIGH_sequence)
        spi_sequence_item seq_item;

        function new(string name = "spi_MOSI_HIGH_sequence");
            super.new(name);
        endfunction

        task body();
           seq_item = spi_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.SS_n=0;
           seq_item.MOSI=1;
           finish_item(seq_item);
        endtask
    endclass

      class spi_MOSI_LOW_sequence extends uvm_sequence #(spi_sequence_item);
         `uvm_object_utils (spi_MOSI_LOW_sequence)
        spi_sequence_item seq_item;

        function new(string name = "spi_MOSI_LOW_sequence");
            super.new(name);
        endfunction

        task body();
           seq_item = spi_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.SS_n=0;
           seq_item.MOSI=0;
           finish_item(seq_item);
        endtask
    endclass

     class spi_finish_frame_sequence extends uvm_sequence #(spi_sequence_item);
         `uvm_object_utils (spi_finish_frame_sequence)
        spi_sequence_item seq_item;

        function new(string name = "spi_finish_frame_sequence");
            super.new(name);
        endfunction

        task body();
           seq_item = spi_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.SS_n=1;
           seq_item.MOSI=0;
           finish_item(seq_item);
        endtask
    endclass

    class spi_MOSI_RND_sequence extends uvm_sequence #(spi_sequence_item);
         `uvm_object_utils (spi_MOSI_RND_sequence)
        spi_sequence_item seq_item;

        function new(string name = "spi_MOSI_RND_sequence");
            super.new(name);
        endfunction

        task body();
           seq_item = spi_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.SS_n=0;
           seq_item.MOSI=$random;
           finish_item(seq_item);
        endtask
    endclass

        class spi_rand_all_sequence extends uvm_sequence #(spi_sequence_item);
        `uvm_object_utils (spi_rand_all_sequence)
        spi_sequence_item seq_item;

        function new(string name = "spi_rand_all_sequence");
            super.new(name);
        endfunction

        task body();
        repeat(100)begin
        seq_item = spi_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
      
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
        endtask
        endclass
endpackage