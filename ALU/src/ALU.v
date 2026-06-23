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
    3'b000 : begin 
        out = add[WIDTH-1:0];
        carry = add[WIDTH];
    end
    3'b001 : begin
        out = sub[WIDTH-1:0];
        carry = sub[WIDTH];
     end
    3'b010 : out = a & b;
    3'b011 : out = a | b;
    3'b100 : out = a ^ b;
    3'b101 : out = ~a;
    3'b110 : out = a;
    3'b111 : out = b;
    default : out = a + b;
    endcase
  end

endmodule
