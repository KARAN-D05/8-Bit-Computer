`timescale 1ns/1ns

module testbench;

  parameter WIDTH = 8;

  reg [WIDTH-1:0] in;
  reg load;
  reg rst;
  reg clk;
  wire [WIDTH-1:0] out;

  PC # ( .WIDTH(WIDTH)
  ) dut (
    .in(in),
    .load(load),
    .rst(rst),
    .clk(clk),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

  $monitor("t = %0t | out = %b | in = %b | load = %b | rst = %b", $time, out, in, load, rst);

  $dumpfile("Sim.vcd");
  $dumpvars(0, testbench);

  in   = 8'h00;
  load = 0;
  rst  = 1;

  // Reset PC
  @(negedge clk);
  #1;
  rst = 0;

  // PC should increment
  @(negedge clk);
  #1;

  @(negedge clk);
  #1;

  @(negedge clk);
  #1;

  // Jump to 0x55
  in   = 8'h55;
  load = 1;

  @(negedge clk);
  #1;
  load = 0;

  // Continue counting from 0x55
  @(negedge clk);
  #1;

  @(negedge clk);
  #1;

  // Jump to 0xA0
  in   = 8'hA0;
  load = 1;

  @(negedge clk);
  #1;
  load = 0;

  // Continue counting from 0xA0
  @(negedge clk);
  #1;

  @(negedge clk);
  #1;

  // test wrap-around
  in   = 8'hFF;
  load = 1;

  @(negedge clk);
  #1;
  load = 0;

  @(negedge clk);
  #1;

  @(posedge clk);
  #1;

  $display("Simulation Complete!");
  $finish;

 end

endmodule
