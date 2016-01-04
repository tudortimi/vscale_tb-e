Reset is implemented as synchronous active high.
<'
extend vgm_ahb::slave_agent {
  event reset_start is only rise(smap.HRESETn$) @unqualified_clock;
};

extend vgm_ahb::monitor {
  event clock is only true(smap.HRESETn$ == 0) @smap.HCLK$;
};

extend vgm_ahb::slave_bfm {
  event clock is only true(smap.HRESETn$ == 0) @smap.HCLK$;
};
'>
