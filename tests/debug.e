<'
import e/vscale_tb_top;


extend vgm_ahb::transfer {
  keep delay == 1;
};


extend MAIN vgm_risc_v::instruction_stream {
  !lui : LUI'kind vgm_risc_v::instruction;
  !add : ADD'kind vgm_risc_v::instruction;

  body() @driver.clock is only {
    do lui keeping {
      .args.rd == x1;
      .args.imm[31:16] == 0xbeef;
      .args.imm[15:12] == 0x0;
    };


    // load '1' in x2
    do lui keeping {
      .args.rd == x2;
      .args.imm[31:16] == 0x0001;
      .args.imm[15:12] == 0x0;
    };

    // load '2' in x3
    do lui keeping {
      .args.rd == x3;
      .args.imm[31:16] == 0x0002;
      .args.imm[15:12] == 0x0;
    };

    // add x2 to x3 and store in x4
    do add keeping {
      .args.rd == x4;
      .args.rs1 == x2;
      .args.rs2 == x3;
    };
  };
};
'>
