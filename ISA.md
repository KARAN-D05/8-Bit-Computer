# Instruction Set Specification

This document serves as the architectural specification for the processor's Instruction Set Architecture (ISA) and Control Unit. It defines the supported instructions, addressing modes, opcode allocation, control word fields, bus encoding, ALU operation encoding, instruction execution timing, and architectural behavior.

## Supported Instructions

| Instruction    | Addressing Mode | Operation            | Total T-States |
| -------------- | --------------- | -------------------- | :------------: |
| LOAD A `<imm>` | Immediate       | A ← imm              |        2       |
| LOAD B `<imm>` | Immediate       | B ← imm              |        2       |
| LDA `<addr>`   | Direct Memory   | A ← RAM[addr]        |        3       |
| LDB `<addr>`   | Direct Memory   | B ← RAM[addr]        |        3       |
| STA `<addr>`   | Direct Memory   | RAM[addr] ← A        |        3       |
| STB `<addr>`   | Direct Memory   | RAM[addr] ← B        |        3       |
| ADD            | Register        | A ← A + B            |        2       |
| SUB            | Register        | A ← A − B            |        2       |
| AND            | Register        | A ← A & B            |        2       |
| OR             | Register        | A ← A  OR B          |        2       |
| XOR            | Register        | A ← A ^ B            |        2       |
| NOT            | Register        | A ← ~A               |        2       |
| PASS A         | Register        | A ← A                |        2       |
| PASS B         | Register        | A ← B                |        2       |
| JMP `<addr>`   | Direct          | PC ← addr            |        2       |
| JC `<addr>`    | Direct          | Jump if Carry = 1    |        2       |
| JZ `<addr>`    | Direct          | Jump if Zero = 1     |        2       |
| JEQ `<addr>`   | Direct          | Jump if A == B       |        2       |
| JGT `<addr>`   | Direct          | Jump if A > B        |        2       |
| JLT `<addr>`   | Direct          | Jump if A < B        |        2       |
| JN `<addr>`    | Direct          | Jump if Negative = 1 |        2       |
| JNC `<addr>`   | Direct          | Jump if Carry = 0    |        2       |
| JNZ `<addr>`   | Direct          | Jump if Zero = 0     |        2       |
| NOP            | Implied         | No Operation         |        2       |
| HLT            | Implied         | Halt Processor       |        2       |

> Total T-States include the universal Fetch cycle (T0).

## Opcode Organization

The processor supports an 8-bit opcode field, allowing a total of **256 instructions**. The opcode space is divided into fixed banks of 32 instructions to simplify instruction decoding and allow future ISA expansion.

| Opcode Range | Hex Range | Category           |
| ------------ | --------- | ------------------ |
| 0–31         | 0x00–0x1F | Data Transfer      |
| 32–63        | 0x20–0x3F | Arithmetic & Logic |
| 64–95        | 0x40–0x5F | Branch & Control   |
| 96–127       | 0x60–0x7F | Reserved           |
| 128–159      | 0x80–0x9F | Reserved           |
| 160–191      | 0xA0–0xBF | Reserved           |
| 192–223      | 0xC0–0xDF | Reserved           |
| 224–255      | 0xE0–0xFF | Reserved           |

## Control Word Format

The Control Unit generates a **16-bit control word** for each instruction and T-state.

| Bit | Control Signal | Description                     |
| --: | -------------- | ------------------------------- |
|  15 | load_A         | Load General Purpose Register A |
|  14 | load_B         | Load General Purpose Register B |
|  13 | load_PC        | Load Program Counter            |
|  12 | enable_PC      | Increment Program Counter       |
|  11 | Write_RAM      | Store Bus Data into RAM         |
|  10 | load_MAR       | Load Memory Address Register    |
|   9 | load_FR        | Load Flag Register              |
|   8 | load_IR        | Load Instruction Register       |
|   7 | ALU_sel[2]     | ALU Operation Select            |
|   6 | ALU_sel[1]     | ALU Operation Select            |
|   5 | ALU_sel[0]     | ALU Operation Select            |
|   4 | Bus_Select[2]  | Bus Source Select               |
|   3 | Bus_Select[1]  | Bus Source Select               |
|   2 | Bus_Select[0]  | Bus Source Select               |
|   1 | TC_clear       | Reset T-State Counter           |
|   0 | TC_enable      | enable T-State Counter          |

## Bus Source Encoding

The processor uses a centralized multiplexer-based shared data bus.

| Bus_Select[2:0] | Bus Source             |
| :-------------: | ---------------------- |
|       000       | Register A             |
|       001       | Register B             |
|       010       | ALU Output             |
|       011       | RAM Output             |
|       100       | IR Operand (`IR[7:0]`) |
|       101       | Reserved               |
|       110       | Reserved               |
|       111       | Reserved               |

## ALU Operation Encoding

| ALU_sel[2:0] | Operation |
| :----------: | --------- |
|      000     | ADD       |
|      001     | SUB       |
|      010     | AND       |
|      011     | OR        |
|      100     | XOR       |
|      101     | NOT       |
|      110     | PASS A    |
|      111     | PASS B    |

## Control Word Table

| Instruction | T-State | load_A | load_B | load_PC | enable_PC | Write_RAM | load_MAR | load_FR | load_IR | ALU_sel[2] | ALU_sel[1] | ALU_sel[0] | Bus_Select[2] | Bus_Select[1] | Bus_Select[0] |TC_clear|TC_en |
|-------------|------|------|------|-------|---------|---------|--------|-------|-------|----|----|----|----|----|----|--------|--------|
| LOAD A `<imm>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |1 |0 |0 |0 |0 |0 |0 |0 | 0| 0|0 |1 |0 |0 |1 |1|
| LOAD B `<imm>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |0 | 1| 0|0 |0 |0 |0 |0 |0 |0 |0 |1 |0 | 0| 1|1 |
| LDA `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |0 | 0| 0|0 |0 |1 |0 | 0| 0|0 |0 |0 | 0| 0| 0|1 |
| | T2 |1 |0 | 0| 0| 0|0 |0 | 0| 0| 0| 0|0 |1 |1 |1 |1 |
| LDB `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |0 |0 | 0| 1|0 |0 |0 |0 |0 |0 | 0| 0|0 |1 |
| | T2 | 0| 1| 0| 0|0 |0 |0 |0 |0 |0 |0 | 0| 1|1 |1 |1 |
| STA `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |0 |0 |0 |0 | 0| 1|0 |0 |0 |0 |0 |0 | 0| 0|0 |1 |
| | T2 |0 | 0| 0| 0|1 |0 | 0| 0|0 | 0| 0| 0| 0| 0|1 |1 |
| STB `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |0 |0 |0 |0 | 0| 1|0 |0 |0 |0 |0 |0 | 0| 1|0 |1 |
| | T2 |0 | 0| 0| 0|1 |0 | 0| 0|0 | 0| 0| 0| 0| 0|1 |1 |
| ADD | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |0 |0 |0 |0 | 1| 0|1 |1|
| SUB | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |0 |0 |1 |0 | 1| 0|1 |1|
| AND | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |0 |1 |0 |0 | 1| 0|1 |1|
| OR | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |0 |1 |1 |0 | 1| 0|1 |1|
| XOR | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |1 |0 |0 |0 | 1| 0|1 |1|
| NOT | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |1 |0 |1 |0 | 1| 0|1 |1|
| PASS A | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |1 |1 |0 |0 | 1| 0|1 |1|
| PASS B | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1|
| | T1 |1 |0 |0 |0 | 0| 0|1 |0 |1 |1 |1 |0 | 1| 0|1 |1 |
| JMP `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JC `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JZ `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JGT `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JEQ `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JN `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JLT `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JNC `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| JNZ `<addr>` | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |1 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1|
| NOP | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |0 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |1 |
| HLT | T0 | 0| 0|0 |1 |0 |0 |0 | 1| 0| 0|0 |0 | 0| 0|0 |1 |
| | T1 |0 |0 |0 |0 | 0| 0|0 |0 |0 |0 |0 |0 | 0| 0|1 |0 |

> Every Jump Instruction produces same control word but whether control unit emits it depends on flags.

## Instruction Encoding

The processor uses an 8-bit opcode field resulting in 256 possible instructions.

### Data Transfer

| Instruction    | Addressing Mode | Opcode (Binary) | Opcode (Hex) | Opcode (Decimal) |
| -------------- | --------------- | :-------------: | :----------: | :--------------: |
| NOP            | Implied         |    `00000000`   |    `0x00`    |         0        |
| LOAD A `<imm>` | Immediate       |    `00000001`   |    `0x01`    |         1        |
| LOAD B `<imm>` | Immediate       |    `00000010`   |    `0x02`    |         2        |
| LDA `<addr>`   | Direct Memory   |    `00000011`   |    `0x03`    |         3        |
| LDB `<addr>`   | Direct Memory   |    `00000100`   |    `0x04`    |         4        |
| STA `<addr>`   | Direct Memory   |    `00000101`   |    `0x05`    |         5        |
| STB `<addr>`   | Direct Memory   |    `00000110`   |    `0x06`    |         6        |

### Arithmetic & Logic

| Instruction | Opcode (Binary) | Opcode (Hex) | Opcode (Decimal) |
| ----------- | :-------------: | :----------: | :--------------: |
| ADD         |    `00100000`   |    `0x20`    |        32        |
| SUB         |    `00100001`   |    `0x21`    |        33        |
| AND         |    `00100010`   |    `0x22`    |        34        |
| OR          |    `00100011`   |    `0x23`    |        35        |
| XOR         |    `00100100`   |    `0x24`    |        36        |
| NOT         |    `00100101`   |    `0x25`    |        37        |
| PASS A      |    `00100110`   |    `0x26`    |        38        |
| PASS B      |    `00100111`   |    `0x27`    |        39        |

### Branch & Control

| Instruction  | Addressing Mode | Opcode (Binary) | Opcode (Hex) | Opcode (Decimal) |
| ------------ | --------------- | :-------------: | :----------: | :--------------: |
| JMP `<addr>` | Direct          |    `01000000`   |    `0x40`    |        64        |
| JC `<addr>`  | Direct          |    `01000001`   |    `0x41`    |        65        |
| JZ `<addr>`  | Direct          |    `01000010`   |    `0x42`    |        66        |
| JEQ `<addr>` | Direct          |    `01000011`   |    `0x43`    |        67        |
| JGT `<addr>` | Direct          |    `01000100`   |    `0x44`    |        68        |
| JLT `<addr>` | Direct          |    `01000101`   |    `0x45`    |        69        |
| JN `<addr>`  | Direct          |    `01000110`   |    `0x46`    |        70        |
| JNC `<addr>` | Direct          |    `01000111`   |    `0x47`    |        71        |
| JNZ `<addr>` | Direct          |    `01001000`   |    `0x48`    |        72        |
| HLT          | Implied         |    `01001001`   |    `0x49`    |        73        |

## Instruction Format

```text
+----------+----------+
| Opcode   | Operand  |
+----------+----------+
| 8 bits   | 8 bits   |
+----------+----------+
```

* For **Immediate** instructions, the operand is interpreted as an 8-bit constant.
* For **Direct Memory** instructions, the operand is interpreted as an 8-bit RAM address.
* For **Branch** instructions, the operand specifies the destination address.
* For **Implied** instructions (NOP and HLT), the operand field is ignored.

## Flag Register

The processor maintains a 5-bit Flag Register.

| Flag     | Description                              |
| -------- | ---------------------------------------- |
| Carry    | Carry generated by arithmetic operations |
| Zero     | Result equals zero                       |
| Negative | Most significant bit of the ALU result   |
| AGTB     | Register A is greater than Register B    |
| AEQB     | Register A is equal to Register B        |

The Flag Register is updated automatically by every Arithmetic & Logic instruction:

* ADD
* SUB
* AND
* OR
* XOR
* NOT
* PASS A
* PASS B

> Data Transfer and Branch instructions do **not** modify the Flag Register.

### Comparison Flags

The `AGTB` (A Greater Than B) and `AEQB` (A Equal B) flags are generated by continuously comparing the ALU input operands (`A` and `B`). When an instruction asserts `load_FR`, these comparison results are latched into the Flag Register alongside the arithmetic flags (`Carry`, `Zero`, `Negative`).

Conditional branch instructions (`JGT`, `JLT`, and `JEQ`) operate on the stored comparison flags from the most recent flag-updating instruction. As a result, comparison and branching are decoupled from arithmetic results, allowing instructions such as `PASS A` to refresh comparison flags without modifying operand values.

- `JGT` : Jump if `A > B`
- `JLT` : Jump if `A < B`
- `JEQ` : Jump if `A == B`

The AGTB and AEQB flags capture the relationship between the ALU input operands (A and B) whenever the Flag Register is updated. Conditional branch instructions (JGT, JLT, JEQ) operate on these stored comparison flags rather than directly on arithmetic results. This design allows comparisons of original operands, arithmetic results, or newly loaded values by explicitly choosing when to refresh the Flag Register (e.g., using PASS A), providing flexible software-controlled comparison semantics.

## ISA Summary

| Category              | Number of Instructions |
|-----------------------|----------------------:|
| Data Transfer         | 7 |
| Arithmetic & Logic    | 8 |
| Branch & Control      | 10 |
| **Total**             | **25** |
