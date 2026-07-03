## RAM

An 8-bit parameterized Random Access Memory with 256 addressable locations.

The RAM serves as the processor's working memory and can store variables, intermediate computation results, and final outputs generated during program execution.

<p align="center">
  <img src="images/ram_waveform.png" width="1000"/>
  <br>
  <sub>RAM Read & Write Operations</sub>
</p>

### Features

* Parameterized memory size
* Parameterized data width
* Synchronous write operation
* Asynchronous read operation
* Byte-addressable storage
* Fully synthesizable Verilog implementation

### Interface

| Signal | Width       | Description    |
| ------ | ----------- | -------------- |
| clk    | 1           | System clock   |
| write  | 1           | Write enable   |
| addr   | log₂(MSIZE) | Memory address |
| in     | WIDTH       | Data input     |
| out    | WIDTH       | Data output    |

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys

| Metric       | Value          |
| ------------ | -------------- |
| Area         | 75862.7584 µm² |
| Cell Count   | 7206           |
| Storage Bits | 2048           |
| D Flip-Flops | 2048           |

## Static Timing Analysis (OpenSTA)

### Scenario 1: Ideal Timing

Clock period constraint:

```text
10 ns
```

No input/output timing constraints applied.

| Metric                  | Value     |
| ----------------------- | --------- |
| Clock Period            | 10 ns     |
| Worst Slack             | 9.28 ns   |
| Estimated Critical Path | 0.72 ns   |
| Estimated Fmax          | ~1.39 GHz |


### Scenario 2: Constrained Timing

Timing constraints:

```text
Input Delay  = 1 ns
Output Delay = 1 ns
Clock Period = 10 ns
```

| Metric                  | Value    |
| ----------------------- | -------- |
| Clock Period            | 10 ns    |
| Worst Slack             | 5.18 ns  |
| Estimated Critical Path | 4.81 ns  |
| Estimated Fmax          | ~208 MHz |


## Timing Comparison

| Scenario        | Worst Slack (ns) | Estimated Fmax |
| --------------- | ---------------- | -------------- |
| Ideal STA       | 9.28             | ~1.39 GHz      |
| Constrained STA | 5.18             | ~208 MHz       |

## Power Analysis

**Operating Frequency:** 100 MHz (10 ns clock period)

| Metric          | Value    |
| --------------- | -------- |
| Internal Power  | 9.46 mW  |
| Switching Power | 0.428 mW |
| Leakage Power   | 26.8 nW  |
| Total Power     | 9.88 mW  |

## Verification

The RAM was verified using RTL simulation and Gate-Level Simulation (GLS).

## Architectural Observation

The Sky130 HD standard-cell library used in this project does not provide a dedicated SRAM macro. As a result, the synthesis flow implemented the RAM using 2048 D Flip-Flops and associated decode/multiplexing logic.

This significantly increases area compared to a true SRAM implementation but accurately reflects the result of synthesizing the behavioral Verilog description using standard cells alone.

The RAM is currently the largest module in the system:

| Module          | Area (µm²) |
| --------------- | ---------: |
| Register        |       ~320 |
| Program Counter |       ~392 |
| ALU             |       ~877 |
| ROM             |      ~2277 |
| RAM             |     ~75863 |

This highlights the substantial area cost of implementing storage using flip-flop based memory structures rather than dedicated SRAM cells.
