module vscale_tb;
  reg clk = 0;
  always #5 clk = ~clk;

  vscale_core dut(.clk(clk));
endmodule
