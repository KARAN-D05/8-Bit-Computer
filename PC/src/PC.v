module PC #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    input load,
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

 always@(posedge clk or posedge rst )begin
    
    if (rst) begin
        out <= 8'b0;
    end else if (load) begin 
        out <= in;
    end else begin
        out <= out + 1;
    end

 end

endmodule
