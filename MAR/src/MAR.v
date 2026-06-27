module MAR #(
    parameter MSIZE = 256
) (
    input [$clog2(MSIZE)-1:0] in,
    input load,
    input clk,
    input rst,
    output reg [$clog2(MSIZE)-1:0] out
);

  always @(posedge clk or posedge rst) begin
    
    if (rst) begin
        out <= {$clog2(MSIZE){1'b0}};
    end else if (load) begin
        out <= in;
    end

  end

endmodule
