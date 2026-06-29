# 8-Bit Computer

An 8-bit Harvard Architecture stored-program computer implemented entirely in synthesizable Verilog.

The processor features a custom Instruction Set Architecture (ISA), a hardwired control unit and parameterized components. It supports arithmetic, logical, memory, and conditional branch instructions while demonstrating the complete RTL-to-Gate synthesis flow using the Sky130 HD standard-cell library.

<p align="center">
  <img src="images/computer_synthesis.png" width="800"/>
  <br>
  <sub>Yosys Synthesis</sub>
</p>

## Architecture

The processor consists of the following major hardware blocks:

* Program Counter (PC)
* Program ROM
* Instruction Register (IR)
* Hardwired Control Unit (CU)
* T-State Counter
* Memory Address Register (MAR)
* Data RAM
* Register A
* Register B
* Arithmetic Logic Unit (ALU)
* Flag Register (FR)
* Shared Internal Bus Multiplexer

The processor follows a Harvard architecture where instruction memory and data memory are physically separated.

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys

| Metric         |          Value |
| -------------- | -------------: |
| Chip Area      | 80347.0592 µm² |

## Static Timing Analysis (OpenSTA)

Clock Constraint

```
10 ns
```

| Metric               |     Value |
| -------------------- | --------: |
| Clock Period         |     10 ns |
| Critical Path Delay  |  25.55 ns |
| Worst Negative Slack | -16.04 ns |

## Timing Analysis

The complete processor successfully synthesized to the Sky130 HD standard-cell library and underwent Static Timing Analysis (STA).

The reported worst negative slack is primarily caused by the behavioral implementation of the 256 × 8 Data RAM. Since the synthesis flow used only standard cells, the memory array was implemented using approximately **2048 D Flip-Flops** together with large address decoding and multiplexing logic rather than a dedicated SRAM macro.

Consequently, the critical path traverses the synthesized memory implementation, making the reported timing representative of the register-based RAM rather than the processor datapath alone.

In a practical ASIC implementation, this memory would typically be replaced with a dedicated SRAM macro, substantially reducing both chip area and critical path delay.


## Power

| Metric               |     Value |
| -------------------- | -------- |
| Total Power          |   8.67 mW |
