module ROM #(
    parameter MSIZE = 256, // Memory Size
    parameter IWIDTH = 8   // Instruction Width
) (
    input [$clog2(MSIZE)-1:0] addr,
    output [IWIDTH-1:0] out
);

  reg [IWIDTH-1:0] mem [MSIZE-1:0];

  integer i;

  initial begin

    for(i=0; i<MSIZE; i=i+1)
      mem[i] = {IWIDTH{1'b0}};

    $readmemh("Program.hex", mem);
  end

  assign out = mem[addr];

endmodule
