# ALU
An 8-bit parameterized combinational Arithmetic Logic Unit (ALU) supporting arithmetic, logical, and data transfer operations.

<p align="center">
  <img src="images/alu_diagram.png" width="500"/>
  <br>
  <sub>ALU Block-Diagram</sub>
</p>

### Supported Operations
| Opcode | Operation | Description                  |
| ------ | --------- | ---------------------------- |
| `000`  | ADD       | Addition (`A + B`)           |
| `001`  | SUB       | Subtraction (`A - B`)        |
| `010`  | AND       | Bitwise AND (`A & B`)        |
| `011`  | OR        | Bitwise OR (`A \| B`)        |
| `100`  | XOR       | Bitwise XOR (`A ^ B`)        |
| `101`  | NOT       | Bitwise NOT (`~A`)           |
| `110`  | PASS A    | Transfer operand A to output |
| `111`  | PASS B    | Transfer operand B to output |

### Status Flags

| Flag    | Description                                                        |
| ------- | ------------------------------------------------------------------ |
| `NEG`   | Asserted when the most significant bit (MSB) of the result is high |
| `ZERO`  | Asserted when the result equals zero                               |
| `AGTB`  | Asserted when operand A is greater than operand B                  |
| `AEQB`  | Asserted when operand A equals operand B                           |
| `CARRY` | Carry-out generated during arithmetic operations                   |

<p align="center">
  <img src="images/alu_synthesis.png" width="600"/>
  <br>
  <sub>ALU synthesized netlist</sub>
</p>

Gate-level simulation was performed after synthesis and technology mapping to verify functional equivalence between RTL and the synthesized Sky130 implementation.

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys

| Metric     | Value        |
| ---------- | ------------ |
| Area       | 877.0912 µm² |

## Static Timing Analysis (OpenSTA)

### Scenario 1: Ideal Timing

Timing assumptions:

* No input timing constraints
* No output timing constraints

| Metric         | Value    |
| -------------- | -------- |
| Critical Path  | 2.21 ns  |
| Estimated Fmax | ~452 MHz |

### Scenario 2: Constrained Timing

Timing constraints:

* Input Delay = 1 ns
* Output Delay = 1 ns

| Metric            | Value    |
| ----------------- | -------- |
| Data Arrival Time | 3.21 ns  |
| Estimated Fmax    | ~311 MHz |

## Timing Comparison

| Scenario        | Critical Path (ns) | Estimated Fmax |
| --------------- | ------------------ | -------------- |
| Ideal STA       | 2.21               | ~452 MHz       |
| Constrained STA | 3.21               | ~311 MHz       |

## Power Analysis

**Operating Frequency:** 100 MHz

| Metric          | Value    |
| --------------- | -------- |
| Total Power     | 349 µW   |
| Internal Power  | 194 µW   |
| Switching Power | 155 µW   |
| Leakage Power   | 0.282 nW |

Power consumption is dominated by combinational switching activity, with negligible leakage contribution.
