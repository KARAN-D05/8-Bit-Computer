module RAM #(
    parameter MSIZE = 256,
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    input write,
    input clk,
    input [$clog2(MSIZE)-1:0] addr,
    output [WIDTH-1:0] out
);

   reg [WIDTH-1:0] mem [MSIZE-1:0];

   assign out = mem[addr];

   always @(posedge clk) begin
 
      if (write) begin
        mem[addr] <= in;
      end  else begin
        mem[addr] <= mem[addr];
      end

   end

endmodule
