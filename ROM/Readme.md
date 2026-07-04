## ROM
An 8-bit parameterized combinational Read-Only Memory with 256 addressable locations.

The ROM outputs instruction/data corresponding to the supplied address and is intended for program storage within the processor architecture.

<p align="center">
  <img src="images/rom_waveform.png" width="1000"/>
  <br>
  <sub>ROM outputting instructions based on address</sub>
</p>

### Interface

| Signal | Width       | Description   |
| ------ | ----------- | ------------- |
| addr   | log₂(MSIZE) | Address input |
| out    | IWIDTH      | Data output   |

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys

| Metric     | Value        |
| ---------- | ------------ |
| Area       | 2277.184 µm² |

## Static Timing Analysis (OpenSTA)

### Scenario 1: Ideal Timing

No input/output timing constraints applied.

| Metric            | Value    |
| ----------------- | -------- |
| Data Arrival Time | 1.85 ns  |
| Estimated Fmax    | ~540 MHz |

### Scenario 2: Constrained Timing

Timing constraints:

```text
Input Delay  = 1 ns
Output Delay = 1 ns
```

| Metric            | Value    |
| ----------------- | -------- |
| Data Arrival Time | 2.85 ns  |
| Estimated Fmax    | ~351 MHz |

### Timing Comparison

| Scenario        | Arrival Time (ns) | Estimated Fmax |
| --------------- | ----------------- | -------------- |
| Ideal STA       | 1.85              | ~540 MHz       |
| Constrained STA | 2.85              | ~351 MHz       |

## Power Analysis

**Operating Frequency:** 100 MHz

| Metric          | Value    |
| --------------- | -------- |
| Internal Power  | 492 µW   |
| Switching Power | 396 µW   |
| Leakage Power   | 0.814 nW |
| Total Power     | 888 µW   |

Power consumption is dominated entirely by combinational switching activity, as the ROM contains no sequential elements.
