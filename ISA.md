# Instruction Set Specification

This document serves as the architectural specification for the processor's instruction set and Control Unit. It defines the supported instructions, addressing modes, control word fields, bus encoding, ALU operation encoding, and instruction execution timing.

# Supported Instructions

| Instruction | Addressing Mode | Operation | Total T-States |
|-------------|-----------------|-----------|:--------------:|
| LOAD A <imm> | Immediate | A ← imm | 2 |
| LOAD B <imm> | Immediate | B ← imm | 2 |
| LDA <addr> | Direct Memory | A ← RAM[addr] | 3 |
| LDB <addr> | Direct Memory | B ← RAM[addr] | 3 |
| STA <addr> | Direct Memory | RAM[addr] ← A | 3 |
| STB <addr> | Direct Memory | RAM[addr] ← B | 3 |

> **Note:** Total T-States include the universal Fetch cycle (T0).

# Control Word Format

The Control Unit generates a 15-bit control word for each instruction and T-state.

| Bit | Control Signal | Description |
|----:|----------------|-------------|
| 14 | load_A | Load General Purpose Register A |
| 13 | load_B | Load General Purpose Register B |
| 12 | load_PC | Load Program Counter |
| 11 | enable_PC | Increment Program Counter |
| 10 | Write_RAM | Store Bus Data into RAM |
| 9 | load_MAR | Load Memory Address Register |
| 8 | load_FR | Load Flag Register |
| 7 | load_IR | Load Instruction Register |
| 6 | ALU_sel[2] | ALU Operation Select |
| 5 | ALU_sel[1] | ALU Operation Select |
| 4 | ALU_sel[0] | ALU Operation Select |
| 3 | Bus_Select[2] | Bus Source Select |
| 2 | Bus_Select[1] | Bus Source Select |
| 1 | Bus_Select[0] | Bus Source Select |
| 0 | TC_clear | Reset T-State Counter |

# Bus Source Encoding

The processor uses a centralized multiplexer-based shared data bus.

| Bus_Select[2:0] | Bus Source |
|:---------------:|------------|
| 000 | Register A |
| 001 | Register B |
| 010 | ALU Output |
| 011 | RAM Output |
| 100 | IR Operand (`IR[7:0]`) |
| 101 | Reserved |
| 110 | Reserved |
| 111 | Reserved |

# ALU Operation Encoding

| ALU_sel[2:0] | Operation |
|:------------:|-----------|
| 000 | ADD |
| 001 | SUB |
| 010 | AND |
| 011 | OR |
| 100 | XOR |
| 101 | NOT |
| 110 | PASS A |
| 111 | PASS B |

# Control Word Table

| Instruction | T-State | load_A | load_B | load_PC | enable_PC | Write_RAM | load_MAR | load_FR | load_IR | ALU_sel[2] | ALU_sel[1] | ALU_sel[0] | Bus_Select[2] | Bus_Select[1] | Bus_Select[0] | TC_clear |
|-------------|------|------|------|-------|---------|---------|--------|-------|-------|----|----|----|----|----|----|--------|
| LOAD A <imm> | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |
| | T1 |1 |0 |0 |0 |0 |0 |0 |0 | 0| 0|0 |1 |0 |0 |1 |
| LOAD B <imm> | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |
| | T1 |0 | 1| 0|0 |0 |0 |0 |0 |0 |0 |0 |1 |0 | 0| 1|
| LDA <addr> | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |
| | T1 |0 | 0| 0|0 |0 |1 |0 | 0| 0|0 |0 |0 | 0| 0| 0|
| | T2 |1 |0 | 0| 0| 0|0 |0 | 0| 0| 0| 0|0 |1 |1 |1 |
| LDB <addr> | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |
| | T1 |0 |0 |0 |0 | 0| 1|0 |0 |0 |0 |0 |0 | 0| 0|0 |
| | T2 | 0| 1| 0| 0|0 |0 |0 |0 |0 |0 |0 | 0| 1|1 |1 |
| STA <addr> | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |
| | T1 |0 |0 |0 |0 | 0| 1|0 |0 |0 |0 |0 |0 | 0| 0|0 |
| | T2 |0 | 0| 0| 0|1 |0 | 0| 0|0 | 0| 0| 0| 0| 0|0 |
| STB <addr> | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |
| | T1 |0 |0 |0 |0 | 0| 1|0 |0 |0 |0 |0 |0 | 0| 0|0 |
| | T2 |0 | 0| 0| 0|1 |0 | 0| 0|0 | 0| 0| 0| 0| 0|0 |
