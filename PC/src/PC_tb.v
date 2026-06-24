`timescale 1ns/1ns

module testbench;

  parameter WIDTH = 8;

  reg clk;
  reg rst;
  reg load;
  reg en;
  reg [WIDTH-1:0] in;
  wire [WIDTH-1:0] out;

  PC #(
    .WIDTH(WIDTH)
  ) dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .en(en),
    .in(in),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor(
      "t = %0t | out = %b | in = %b | enable = %b | load = %b | rst = %b",
      $time, out, in, en, load, rst
    );

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    in     = 0;
    load   = 0;
    en     = 0;
    rst    = 1;

    // Release reset
    @(negedge clk);
    #1;
    rst = 0;

    // Count: 0 -> 1 -> 2 -> 3
    @(negedge clk);
    #1;
    en     = 1;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    // Hold at 3
    @(negedge clk);
    #1;
    en     = 0;

    @(posedge clk);
    @(posedge clk);

    // Load 0x55
    @(negedge clk);
    #1;
    in   = 8'h55;
    load = 1;

    @(negedge clk);
    #1;
    load = 0;

    // Hold at 0x55
    @(posedge clk);

    // Resume counting
    @(negedge clk);
    #1;
    en    = 1;

    @(posedge clk);
    @(posedge clk);

    // Verify load has priority over increment
    @(negedge clk);
    #1;
    in     = 8'hA0;
    load   = 1;
    en   = 1;

    @(negedge clk);
    #1;
    load = 0;

    // Count from A0
    @(posedge clk);
    @(posedge clk);

    // Wrap-around test
    @(negedge clk);
    #1;
    in   = 8'hFF;
    load = 1;

    @(negedge clk);
    #1;
    load = 0;

    @(posedge clk); // FF -> 00
    @(posedge clk); // 00 -> 01

    #1;
    $display("Simulation Complete!");
    $finish;

  end

endmodule
