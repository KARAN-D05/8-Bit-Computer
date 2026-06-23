# ALU
An 8-bit parameterized combinational Arithmetic Logic Unit (ALU) supporting arithmetic, logical, and data transfer operations.

<p align="center">
  <img src="images/alu_waveform.png" width="1000"/>
  <br>
  <sub>ALU performing arithmetic and logical operations</sub>
</p>

### Supported Operations
* Addition (ADD)
* Subtraction (SUB)
* Bitwise AND
* Bitwise OR
* Bitwise XOR
* Bitwise NOT
* Pass A
* Pass B

### Status Flags
* NEG - Indicates a negative result (MSB of output)
* ZERO - Indicates output equals zero
* AGTB - Indicates A > B
* AEQB - Indicates A = B
* CARRY - Carry-out generated during arithmetic operations

Gate-level simulation (GLS) was performed after synthesis and technology mapping to verify functional equivalence between RTL and the synthesized Sky130 implementation.

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
