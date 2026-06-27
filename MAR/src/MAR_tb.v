`timescale 1ns/1ns

module testbench;

  parameter MSIZE = 256;

  reg [$clog2(MSIZE)-1:0] in;
  reg load;
  reg clk;
  reg rst;
  wire [$clog2(MSIZE)-1:0] out;

  MAR #(
    .MSIZE(MSIZE)
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

    $monitor("t = %0t | in = %b | load = %b | rst = %b | out = %b", $time, in, load, rst, out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    in = 0;
    rst = 1;
    load = 0;

    @(negedge clk);
    #1;
    rst = 0;

    @(negedge clk);
    #1;
    in = 8'b11001100;
    load = 1;

    @(posedge clk);
    @(posedge clk);

    @(negedge clk);
    #1;
    in = 8'b11111111;
    load = 1;

    @(negedge clk);
    #1;
    in = 8'b10000001;
    load = 0;

    @(posedge clk);
    @(posedge clk);

    rst = 1;

    @(posedge clk);

    $display("Simulation Complete");
    $finish;

  end

endmodule
