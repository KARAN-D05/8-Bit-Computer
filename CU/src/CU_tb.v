`timescale 1ns/1ns

module testbench;

reg [2:0] t_state;
reg [7:0] opcode;
reg carry;
reg zero;
reg neg;
reg agtb;
reg aeqb;

wire load_A;
wire load_B;
wire load_PC;
wire enable_PC;
wire Write_RAM;
wire load_MAR;
wire load_FR;
wire load_IR;
wire [2:0] ALU_sel;
wire [2:0] Bus_Select;
wire TC_clear;

CU dut (
    .t_state(t_state),
    .opcode(opcode),
    .carry(carry),
    .zero(zero),
    .neg(neg),
    .agtb(agtb),
    .aeqb(aeqb),

    .load_A(load_A),
    .load_B(load_B),
    .load_PC(load_PC),
    .enable_PC(enable_PC),
    .Write_RAM(Write_RAM),
    .load_MAR(load_MAR),
    .load_FR(load_FR),
    .load_IR(load_IR),
    .ALU_sel(ALU_sel),
    .Bus_Select(Bus_Select),
    .TC_clear(TC_clear)
);

initial begin

    $monitor(
    "t=%0t | opcode=%h | T=%0d | C=%b Z=%b N=%b GT=%b EQ=%b | loadA=%b loadB=%b loadPC=%b enPC=%b WR=%b MAR=%b FR=%b IR=%b ALU=%b BUS=%b CLR=%b",
    $time,
    opcode,
    t_state,
    carry,
    zero,
    neg,
    agtb,
    aeqb,
    load_A,
    load_B,
    load_PC,
    enable_PC,
    Write_RAM,
    load_MAR,
    load_FR,
    load_IR,
    ALU_sel,
    Bus_Select,
    TC_clear
    );

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    // LOAD A <imm>
    opcode = 8'h01;
    carry = 0;
    zero = 0;
    neg = 0;
    agtb = 0;
    aeqb = 0;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // LDA
    opcode = 8'h03;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    t_state = 2;
    #10;

    // ADD
    opcode = 8'h20;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // JMP
    opcode = 8'h40;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // JC (Taken)
    opcode = 8'h41;
    carry = 1;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // JC (Not Taken)
    carry = 0;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // JEQ
    opcode = 8'h43;
    aeqb = 1;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // JGT
    opcode = 8'h44;
    aeqb = 0;
    agtb = 1;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    // JLT
    opcode = 8'h45;
    agtb = 0;
    aeqb = 0;

    t_state = 0;
    #10;

    t_state = 1;
    #10;

    $display("Simulation Complete");
    $finish;

end

endmodule
