<'
import e/vscale_tb_top;


extend vgm_ahb::transfer {
  keep delay == 1;
};


extend MAIN vgm_risc_v::instruction_stream {
  !instr : vgm_risc_v::instruction;

  body() @driver.clock is only {
    do SW instr;

    wait [6];

    var sw := instr.as_a(SW vgm_risc_v::instruction);
    do LW instr keeping {
      .args.rs1 == sw.args.rs1;
      .args.imm == sw.args.imm;
    };
  };
};
'>
