`include timescale 1ns/1ns

module testbench;

  parameter WIDTH = 8;

  reg [WIDTH-1:0] in;
  reg load;
  reg rst;
  reg clk;
  wire [WIDTH-1:0] out;

  A_Register #(
    .WIDTH(WIDTH)
    dut(
    .in(in),
    .loadA(load),
    .rst(rst),
    .clk(clk),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

   $monitor("t = %0t | in = %b | load = %b | rst = %b | out = %b", $time, in, load, rst, out);

   $dumpfile("Sim.vcd");
   $dumpvars(0, testbench);

  in     = 8'b00000000;
  load   = 0;
  rst    = 1;

  @(negedge clk);
  #1;
  rst = 0;

  @(negedge clk);
  #1;
  in     = 8'b11111111;
  load   = 1;

  @(negedge clk);
  #1;
  load   = 0;

  @(negedge clk);
  #1;
  in     = 8'b10101010;
  load   = 1;

  @(negedge clk);
  #1;
  in     = 8'b10000001;
  load   = 1;

  @(posedge clk);
  #1;

   $display("Simulation Complete!");
   $finish;

  end

endmodule
