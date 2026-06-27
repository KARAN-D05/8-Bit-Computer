`timescale 1ns/1ns

module testbench;

  parameter IWIDTH = 16;

  reg [IWIDTH-1:0] in;
  reg load;
  reg clk;
  reg rst;
  wire [IWIDTH-1:0] out;

  IR #(
    .IWIDTH(IWIDTH)
  ) dut (
    .in(in),
    .load(load),
    .clk(clk),
    .rst(rst),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor(
      "t = %0t | in = %b | load = %b | rst = %b | out = %b",
      $time, in, load, rst, out
    );

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    in   = 16'b0000000000000000;
    load = 0;
    rst  = 1;

    // Release reset
    @(negedge clk);
    #1;
    rst = 0;

    // Load first instruction
    @(negedge clk);
    #1;
    in   = 16'b0000000100100011;
    load = 1;

    @(negedge clk);
    #1;
    load = 0;

    // Hold previous instruction
    @(posedge clk);
    @(posedge clk);

    // Load second instruction
    @(negedge clk);
    #1;
    in   = 16'b1010101011110000;
    load = 1;

    @(negedge clk);
    #1;
    load = 0;

    // Hold again
    @(posedge clk);
    @(posedge clk);

    // Load all ones
    @(negedge clk);
    #1;
    in   = 16'b1111111111111111;
    load = 1;

    @(negedge clk);
    #1;
    load = 0;

    @(posedge clk);

    // Asynchronous reset
    @(negedge clk);
    #1;
    rst = 1;

    @(posedge clk);
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
