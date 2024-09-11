package spi_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_env_pkg::*;
import spi_config_pkg::*;
import spi_sequence_pkg::*;
import spi_agent_pkg::*;
class spi_test extends uvm_test;
    `uvm_component_utils(spi_test)

   
    spi_env env;
    spi_config spi_cfg;
    virtual spi_inter spi_vif_test;
    virtual golden_inter_ref gold_vif_test;
    spi_reset_sequence reset_seq;
    spi_MOSI_LOW_sequence mslw_seq;
    spi_MOSI_HIGH_sequence mshi_seq;
    spi_MOSI_RND_sequence msrd_seq;
    spi_rand_all_sequence rnd_seq;
    spi_finish_frame_sequence fnsh_frm_seq;
    function new(string name="spi_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=spi_env::type_id::create("env",this);
        spi_cfg=spi_config::type_id::create("spi_cfg",this);
        reset_seq=spi_reset_sequence::type_id::create("reset_seq",this);
        mslw_seq=spi_MOSI_LOW_sequence::type_id::create("mslw_seq",this);
        mshi_seq=spi_MOSI_HIGH_sequence::type_id::create("mshi_seq",this);
        msrd_seq=spi_MOSI_RND_sequence::type_id::create("msrd_seq",this);
        rnd_seq=spi_rand_all_sequence::type_id::create("rnd_seq",this);
        fnsh_frm_seq=spi_finish_frame_sequence::type_id::create("fnsh_frm_seq",this);

        if(!uvm_config_db #(virtual spi_inter)::get(this,"","SPI_IF",spi_cfg.spi_vif_config))
        `uvm_fatal("build_phase","Test - Unable to get the virtual interface of the SPI from the uvm_config_db")
        
        if(!uvm_config_db #(virtual golden_inter_ref)::get(this,"","GOLDEN_IF",spi_cfg.gold_vif_config))
        `uvm_fatal("build_phase","Test - Unable to get the virtual golden interface of the SPI from the uvm_config_db")
        uvm_config_db #(spi_config)::set(this,"*","CFG",spi_cfg);
    endfunction


    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","reset_deasserted",UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase","reset_asserted",UVM_LOW)
 repeat(10)begin
    `uvm_info("run_phase","wradd_asserted",UVM_LOW)
    mslw_seq.start(env.agt.sqr);
    mslw_seq.start(env.agt.sqr);
    mslw_seq.start(env.agt.sqr);
    mslw_seq.start(env.agt.sqr);
   repeat(10)begin
    msrd_seq.start(env.agt.sqr);
   end
    `uvm_info("run_phase","wradd_deasserted",UVM_LOW)
    fnsh_frm_seq.start(env.agt.sqr);
    `uvm_info("run_phase","wrdata_asserted",UVM_LOW)
     mslw_seq.start(env.agt.sqr);
    mslw_seq.start(env.agt.sqr);
    mslw_seq.start(env.agt.sqr);
    mshi_seq.start(env.agt.sqr);
   repeat(10)begin
    msrd_seq.start(env.agt.sqr);
   end
    `uvm_info("run_phase","wrdata_deasserted",UVM_LOW)
fnsh_frm_seq.start(env.agt.sqr);
    `uvm_info("run_phase","rdadd_asserted",UVM_LOW)
   mslw_seq.start(env.agt.sqr);
    mshi_seq.start(env.agt.sqr);
    mshi_seq.start(env.agt.sqr);
    mslw_seq.start(env.agt.sqr);
   repeat(10)begin
    msrd_seq.start(env.agt.sqr);
   end
    `uvm_info("run_phase","rdadd_deasserted",UVM_LOW)
fnsh_frm_seq.start(env.agt.sqr);
    `uvm_info("run_phase","rddata_asserted",UVM_LOW)
    mslw_seq.start(env.agt.sqr);
    mshi_seq.start(env.agt.sqr);
    mshi_seq.start(env.agt.sqr);
    mshi_seq.start(env.agt.sqr);
   repeat(18)begin
    msrd_seq.start(env.agt.sqr);
   end
    `uvm_info("run_phase","rddata_deasserted",UVM_LOW)
fnsh_frm_seq.start(env.agt.sqr);end
    `uvm_info("run_phase","rndall_asserted",UVM_LOW)
    rnd_seq.start(env.agt.sqr);
    `uvm_info("run_phase","rndall_deasserted",UVM_LOW)
    fnsh_frm_seq.start(env.agt.sqr);
    repeat(10)begin
        reset_seq.start(env.agt.sqr);
    end
    phase.drop_objection(this);

    endtask
      

endclass :spi_test


endpackage