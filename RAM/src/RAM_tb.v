`timescale 1ns/1ns

module testbench;

  parameter MSIZE = 256;
  parameter WIDTH = 8;

  reg [WIDTH-1:0] in;
  reg write;
  reg clk;
  reg [$clog2(MSIZE)-1:0] addr;
  wire [WIDTH-1:0] out;

  RAM #(
    .MSIZE(MSIZE),
    .WIDTH(WIDTH)
  ) dut (
    .in(in),
    .write(write),
    .clk(clk),
    .addr(addr),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor(
      "t = %0t | addr = %3d | in = %b | write = %b | out = %b",
      $time, addr, in, write, out
    );

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    in    = 0;
    addr  = 0;
    write = 0;

    // Write 0xAA to address 10
    @(negedge clk);
    #1;
    addr  = 8'd10;
    in    = 8'b10101010;
    write = 1;

    @(negedge clk);
    #1;
    write = 0;

    // Read address 10
    @(negedge clk);
    #1;
    addr = 8'd10;

    // Write 0x55 to address 20
    @(negedge clk);
    #1;
    addr  = 8'd20;
    in    = 8'b01010101;
    write = 1;

    @(negedge clk);
    #1;
    write = 0;

    // Read address 20
    @(negedge clk);
    #1;
    addr = 8'd20;

    // Overwrite address 10
    @(negedge clk);
    #1;
    addr  = 8'd10;
    in    = 8'b11111111;
    write = 1;

    @(negedge clk);
    #1;
    write = 0;

    // Read address 10 again
    @(negedge clk);
    #1;
    addr = 8'd10;

    // Read unwritten address 30
    @(negedge clk);
    #1;
    addr = 8'd30;

    @(posedge clk);
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule