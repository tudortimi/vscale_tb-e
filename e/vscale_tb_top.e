<'
import vgm_ahb/e/vgm_ahb_top;
import vgm_risc_v/e/vgm_risc_v_top;
import vgm_risc_v_ahb/e/vgm_risc_v_ahb_top;

import vscale_tb_ahb_extensions;
import vscale_tb_env;


extend sys {
  env : vscale_tb_env is instance;
    keep env.hdl_path() == "vscale_tb.dut";
};
'>
