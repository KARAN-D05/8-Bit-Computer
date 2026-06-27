// Instruction Register
module IR #(
    parameter IWIDTH = 16
) (
    input [IWIDTH-1:0] in,
    input load,
    input clk,
    input rst,
    output reg [IWIDTH-1:0] out
);

  always@(posedge clk or posedge rst) begin
    
    if (rst) begin
        out <= {IWIDTH{1'b0}};
    end else if (load) begin
        out <= in;
    end

  end

endmodule
