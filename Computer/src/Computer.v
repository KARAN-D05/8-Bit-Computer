`include "PC.v"
`include "IR.v"
`include "CU.v"
`include "ROM.v"
`include "TC.v"
`include "MAR.v"
`include "RAM.v"
`include "BusMux.v"
`include "ALU.v"
`include "FR.v"
`include "A_Register.v"
`include "B_Register.v"

module Computer(

    input clk,
    input rst

);

wire [7:0]  pc;         // PC -> ROM Address
wire [15:0] rom_out;    // ROM -> IR
wire [15:0] ir_out;     // IR -> CU (Opcode), MAR & Bus (Operand)
wire [2:0] t_state;     // T-State Counter -> CU
wire [7:0] mar_out;     // MAR -> RAM Address
wire [7:0] ram_out;     // RAM -> Bus MUX
wire [7:0] a_out;       // Register A -> ALU & Bus MUX
wire [7:0] b_out;       // Register B -> ALU & Bus MUX
wire [7:0] alu_out;     // ALU -> Bus MUX
wire [7:0] bus;         // Bus MUX -> Registers & RAM
wire carry;             // ALU -> Flag Register
wire zero;
wire neg;
wire agtb;
wire aeqb;
wire carry_flag;        // Flag Register -> CU
wire zero_flag;
wire neg_flag;
wire agtb_flag;
wire aeqb_flag;
wire load_A;            // Register A Load
wire load_B;            // Register B Load
wire load_PC;           // Program Counter Load
wire enable_PC;         // Program Counter Increment
wire Write_RAM;         // RAM Write Enable
wire load_MAR;          // Memory Address Register Load
wire load_FR;           // Flag Register Load
wire load_IR;           // Instruction Register Load
wire [2:0] ALU_sel;     // ALU Operation Select
wire [2:0] Bus_Select;  // Bus Multiplexer Select
wire TC_clear;          // T-State Counter Clear
wire TC_enable;         // T-State Counter Enable

PC pc_inst(

    .in(ir_out[7:0]),
    .load(load_PC),
    .clk(clk),
    .rst(rst),
    .en(enable_PC),
    .out(pc)

);

ROM #(

    .MSIZE(256),
    .IWIDTH(16)
) rom_inst (

    .addr(pc),
    .out(rom_out)

);

IR ir_inst(

    .in(rom_out),
    .load(load_IR),
    .clk(clk),
    .rst(rst),
    .out(ir_out)

);

TC tc_inst(

    .clear(TC_clear),
    .clk(clk),
    .enable(TC_enable),
    .rst(rst),
    .out(t_state)

);

MAR mar_inst(

    .in(ir_out[7:0]),
    .load(load_MAR),
    .clk(clk),
    .rst(rst),
    .out(mar_out)

);

RAM ram_inst(

    .in(bus),
    .write(Write_RAM),
    .clk(clk),
    .addr(mar_out),
    .out(ram_out)

);

A_Register a_reg(

    .in(bus),
    .loadA(load_A),
    .rst(rst),
    .clk(clk),
    .out(a_out)

);

B_Register b_reg(

    .in(bus),
    .loadB(load_B),
    .rst(rst),
    .clk(clk),
    .out(b_out)

);

ALU alu(

    .a(a_out),
    .b(b_out),
    .sel(ALU_sel),
    .out(alu_out),
    .neg(neg),
    .zero(zero),
    .agtb(agtb),
    .aeqb(aeqb),
    .carry(carry)

);

FR fr(

    .carry(carry),
    .neg(neg),
    .agtb(agtb),
    .aeqb(aeqb),
    .zero(zero),
    .clk(clk),
    .load(load_FR),
    .rst(rst),
    .carry_out(carry_flag),
    .neg_out(neg_flag),
    .agtb_out(agtb_flag),
    .aeqb_out(aeqb_flag),
    .zero_out(zero_flag)

);

BusMux bus_mux(

    .A(a_out),
    .B(b_out),
    .ALU(alu_out),
    .RAM(ram_out),
    .IR(ir_out[7:0]),
    .sel(Bus_Select),
    .bus(bus)

);

CU cu_inst(

    .t_state(t_state),
    .opcode(ir_out[15:8]),
    .carry(carry_flag),
    .zero(zero_flag),
    .neg(neg_flag),
    .agtb(agtb_flag),
    .aeqb(aeqb_flag),
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
    .TC_clear(TC_clear),
    .TC_enable(TC_enable)

);

endmodule
