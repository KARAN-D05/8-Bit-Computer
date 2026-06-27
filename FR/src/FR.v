// Flags Register

module FR (
    input carry,
    input neg,
    input agtb,
    input aeqb,
    input zero,
    input clk,
    input load,
    input rst,
    output reg carry_out,
    output reg neg_out,
    output reg agtb_out,
    output reg aeqb_out,
    output reg zero_out
);

  always @(posedge clk or posedge rst) begin
    
    if (rst) begin
        carry_out <= 0;
        neg_out <= 0;
        agtb_out <= 0;
        aeqb_out <= 0;
        zero_out <= 0;
    end else if (load) begin
        carry_out <= carry;
        neg_out <= neg;
        agtb_out <= agtb;
        aeqb_out <= aeqb;
        zero_out <= zero;
    end

  end

endmodule
