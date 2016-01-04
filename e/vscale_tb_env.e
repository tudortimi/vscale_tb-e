<'
unit vscale_tb_smap {
  reset : inout simple_port of bit is instance;

  clock : in event_port is instance;
    keep clock.edge() == MVL_0_to_1;
};


unit vscale_tb_env {
  smap : vscale_tb_smap is instance;
    keep smap.reset.hdl_path() == "htif_reset";
    keep smap.clock.hdl_path() == "clk";

  event unqualified_clock is @smap.clock$;
  event clock is true(smap.reset$ == 0) @unqualified_clock;

  run() is also {
    start reset();
  };

  reset() @unqualified_clock is {
    smap.reset$ = 1;
    wait [5];
    smap.reset$ = 0;
  };
};
'>



<'
extend vgm_ahb::agent_id : [ IMEM, DMEM ];

extend vscale_tb_env {
  imem_agent : IMEM vgm_ahb::slave_agent is instance;
    keep imem_agent.smap.HRESETn.hdl_path() == "htif_reset";
    keep imem_agent.smap.HCLK.hdl_path() == "clk";
    keep imem_agent.smap.HWRITE.hdl_path() == "imem_hwrite";
    keep imem_agent.smap.HADDR.hdl_path() == "imem_haddr";
    keep imem_agent.smap.HTRANS.hdl_path() == "imem_htrans";
    keep imem_agent.smap.HWDATA.hdl_path() == "imem_hwdata";
    keep imem_agent.smap.HREADY.hdl_path() == "imem_hready";
    keep imem_agent.smap.HRESP.hdl_path() == "imem_hresp";
    keep imem_agent.smap.HRDATA.hdl_path() == "imem_hrdata";

  dmem_agent : DMEM vgm_ahb::slave_agent is instance;
    keep dmem_agent.smap.HRESETn.hdl_path() == "htif_reset";
    keep dmem_agent.smap.HCLK.hdl_path() == "clk";
    keep dmem_agent.smap.HWRITE.hdl_path() == "dmem_hwrite";
    keep dmem_agent.smap.HADDR.hdl_path() == "dmem_haddr";
    keep dmem_agent.smap.HTRANS.hdl_path() == "dmem_htrans";
    keep dmem_agent.smap.HWDATA.hdl_path() == "dmem_hwdata";
    keep dmem_agent.smap.HREADY.hdl_path() == "dmem_hready";
    keep dmem_agent.smap.HRESP.hdl_path() == "dmem_hresp";
    keep dmem_agent.smap.HRDATA.hdl_path() == "dmem_hrdata";
};
'>



Implement instruction layering
<'
extend vscale_tb_env {
  istream_driver : vgm_risc_v::instruction_stream_driver is instance;

  on imem_agent.driver.clock {
    emit istream_driver.clock;
  };
};


extend IMEM MAIN vgm_ahb::slave_sequence {
  !layer_seq : INSTRUCTION_LAYERING vgm_ahb::slave_sequence;

  body() @driver.clock is only {
    do layer_seq keeping {
      .stream_driver == driver.get_enclosing_unit(vscale_tb_env).istream_driver;
    };
  };
};
'>



Implement data memory
<'
extend DMEM MAIN vgm_ahb::slave_sequence {
  !memory_seq : MEMORY vgm_ahb::slave_sequence;

  body() @driver.clock is only {
    do memory_seq;
  };
};
'>


Implement end-of-test
<'
extend MAIN vgm_risc_v::instruction_stream {
  pre_body() @sys.any is first {
    driver.raise_objection(TEST_DONE);
  };

  post_body() @sys.any is also {
    wait [5];  // Flush the pipeline.
    driver.drop_objection(TEST_DONE);
  };
};


// TODO implement objection on DMEM side when ongoing transfer
'>
