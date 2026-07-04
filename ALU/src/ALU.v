// Supports 8 Operations: ADD, SUB, AND, OR, NOT A, XOR, PASS A, PASS B
// 5 Flags: neg(negative result), zero(zero result), agtb(a>b), aeqb(a=b), carry(out[WIDTH])

module ALU #(
    parameter WIDTH = 8,
    parameter NUM_OPS = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [$clog2(NUM_OPS)-1:0] sel,
    output reg [WIDTH-1:0] out,
    output neg,
    output zero,
    output agtb,
    output aeqb,
    output reg carry
);

  localparam [$clog2(NUM_OPS)-1:0] OP_ADD = 0;
  localparam [$clog2(NUM_OPS)-1:0] OP_SUB = 1;
  localparam [$clog2(NUM_OPS)-1:0] OP_AND = 2;
  localparam [$clog2(NUM_OPS)-1:0] OP_OR = 3;
  localparam [$clog2(NUM_OPS)-1:0] OP_XOR = 4;
  localparam [$clog2(NUM_OPS)-1:0] OP_NOT_A = 5;
  localparam [$clog2(NUM_OPS)-1:0] OP_PASS_A = 6;
  localparam [$clog2(NUM_OPS)-1:0] OP_PASS_B = 7;

  wire [WIDTH:0] add, sub;
  assign add = a + b;
  assign sub = a - b; 

  assign agtb = (a > b) ? 1 : 0;
  assign aeqb = (a == b) ? 1 : 0;
  assign zero = ~(|out);
  assign neg = out[WIDTH-1];

  always@(*) begin

    carry = 0;

    case (sel)
    OP_ADD : begin 
        out = add[WIDTH-1:0];
        carry = add[WIDTH];
    end
    OP_SUB : begin
        out = sub[WIDTH-1:0];
        carry = sub[WIDTH];
     end
    OP_AND : out = a & b;
    OP_OR : out = a | b;
    OP_XOR : out = a ^ b;
    OP_NOT_A : out = ~a;
    OP_PASS_A : out = a;
    OP_PASS_B : out = b;
    default : out = a + b;
    endcase
  end

endmodule
