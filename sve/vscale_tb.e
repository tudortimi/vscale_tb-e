<'
extend sys {
  env : vscale_tb_env is instance;
    keep env.hdl_path() == "vscale_tb.dut";
};
'>
