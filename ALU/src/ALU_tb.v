`timescale 1ns/1ns

module testbench;

  parameter WIDTH = 8;
  parameter NUM_OPS = 8;

  reg [WIDTH-1:0] a;
  reg [WIDTH-1:0] b;
  reg [$clog2(NUM_OPS)-1:0] sel;
  wire [WIDTH-1:0] out;
  wire neg;
  wire zero;
  wire agtb;
  wire aeqb;
  wire carry;

  ALU #(
    .WIDTH(WIDTH),
    .NUM_OPS(NUM_OPS)
) dut (
    .a(a),
    .b(b),
    .sel(sel),
    .out(out),
    .neg(neg),
    .zero(zero),
    .agtb(agtb),
    .aeqb(aeqb),
    .carry(carry)
  );

  initial begin

   $monitor("time = %0t | a = %b | b = %b | sel = %b | out = %b | neg = %b | zero = %b | agtb = %b | aeqb = %b | carry = %b"
   , $time, a, b, sel, out, neg, zero, agtb, aeqb, carry);

   $dumpfile("Sim.vcd");
   $dumpvars(0, testbench);
   
   // ADD (3+1)
   a = 8'b00000011;
   b = 8'b00000001;
   sel = 3'b000;
   #5;

   // ADD (255+1)
   a = 8'b11111111;
   b = 8'b00000001;
   sel = 3'b000;
   #5;

   // SUB (3-1)
   a = 8'b00000011;
   b = 8'b00000001;
   sel = 3'b001;
   #5;

   // SUB (3-7)
   a = 8'b00000011;
   b = 8'b00000111;
   sel = 3'b001;
   #5;

   // SUB (0-1)
   a = 8'b00000000;
   b = 8'b00000001;
   sel = 3'b001;
   #5;
   
   // AND 
   a = 8'b11100110;
   b = 8'b01111111;
   sel = 3'b010;
   #5;
  
   // OR
   a = 8'b11100110;
   b = 8'b01111111;
   sel = 3'b011;
   #5;

   // XOR
   a = 8'b11100110;
   b = 8'b01111111;
   sel = 3'b100;
   #5;
   
   // NOT a
   a = 8'b11111111;
   b = 8'b11111111;
   sel = 3'b101;
   #5;

   // PASS a
   a = 8'b11100110;
   b = 8'b01111111;
   sel = 3'b110;
   #5;

   // PASS b
   a = 8'b11100110;
   b = 8'b01111111;
   sel = 3'b111;
   #5;


   $display("Simulation Complete!");
   $finish;

  end

endmodule
