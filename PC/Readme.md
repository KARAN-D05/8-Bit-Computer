# Program Counter (PC)
An 8-bit parameterized loadable counter with asynchronous reset used to track instruction addresses during program execution.

### Features
* Asynchronous reset
* Automatic address incrementation
* Supports loading arbitrary addresses for jump operations
* Natural wrap-around at maximum address value (0xFF → 0x00)
* Parameterized width for scalability

<p align="center">
  <img src="images/pc_waveform.png" width="1000"/>
  <br>
  <sub>Program Counter incrementing on enable and loading new values on load</sub>
</p>

### Functional Behavior

| Condition | Operation   |
| --------- | ----------- |
| rst = 1   | PC ← 0      |
| load = 1  | PC ← in     |
| en = 1    | PC ← PC + 1 |

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys

| Metric     | Value        |
| ---------- | ------------ |
| Area       | 444.176 µm² |

## Static Timing Analysis (OpenSTA)

### Scenario 1: Ideal Timing

Clock period constraint:

```text
10 ns
```

No input/output timing constraints applied.

| Metric            | Value       |
| ----------------- | ----------- |
| Clock Period      | 10 ns       |
| Worst Slack       | 8.75 ns     |
| Data Arrival Time | 1.12 ns     |
| Setup Time        | 0.13 ns     |
| Estimated Fmax    | ~800 MHz |

### Scenario 2: Constrained Timing

Timing constraints:

```text
Input Delay  = 1 ns
Output Delay = 1 ns
Clock Period = 10 ns
```

| Metric            | Value       |
| ----------------- | ----------- |
| Clock Period      | 10 ns       |
| Worst Slack       | 8.22 ns     |
| Data Arrival Time | 1.70 ns     |
| Setup Time        | 0.08 ns     |
| Estimated Fmax    | ~561.79 MHz |

## Timing Comparison

| Scenario        | Worst Slack (ns) | Estimated Fmax |
| --------------- | ---------------- | -------------- |
| Ideal STA       | 8.75             | ~800 MHz    |
| Constrained STA | 8.22             | ~561.79 MHz |

## Power Analysis

**Operating Frequency:** 100 MHz (10 ns clock period)

| Metric          | Value    |
| --------------- | -------- |
| Total Power     | 48.1 µW  |
| Internal Power  | 41.2 µW  |
| Switching Power | 6.98 µW  |
| Leakage Power   | 0.179 nW |

## Verification

The Program Counter was verified using RTL simulation and Gate-Level Simulation (GLS).
RTL and GLS outputs matched, confirming functional equivalence between the behavioral description and the synthesized Sky130 gate-level implementation.
