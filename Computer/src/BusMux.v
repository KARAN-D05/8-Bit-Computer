// Bus-Output-Select-Mux
module BusMux #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [WIDTH-1:0] ALU,
    input  [WIDTH-1:0] RAM,
    input  [WIDTH-1:0] IR,
    input  [2:0] sel,
    output reg [WIDTH-1:0] bus
);

always @(*) begin

    case (sel)

        3'b000: bus = A;
        3'b001: bus = B;
        3'b010: bus = ALU;
        3'b011: bus = RAM;
        3'b100: bus = IR;

        default: bus = {WIDTH{1'b0}};

    endcase

end

endmodule
