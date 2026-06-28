// B Register 
module B_Register #(
    parameter WIDTH = 8 
)(
    input [WIDTH-1:0] in,
    input loadB,
    input rst,
    input clk,
    output reg [WIDTH-1:0] out
);

  always@(posedge clk or posedge rst) begin
    
    if(rst) begin
        out <= {WIDTH{1'b0}};
    end else if (loadB) begin
        out <= in;
    end

  end

endmodule
