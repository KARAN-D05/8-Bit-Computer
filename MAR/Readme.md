# Memory Address Register (MAR)

An 8-bit (Parameterized) loadable Memory Address Register with asynchronous reset. The MAR stores the address used to access memory and loads a new address on the positive edge of the clock when the `load` signal is asserted.

## Features

- Parameterized address width
- Asynchronous active-high reset
- Synchronous address loading
- Holds previous address when load = 0

<p align="center">
  <img src="images/mar_waveform.png" width="1000"/>
  <br>
  <sub>Memory Address Register </sub>
</p>

## Synthesis Results

**Technology:** Sky130 HD  
**Synthesis Tool:** Yosys

| Metric | Value |
|--------|-------:|
| Area | 320.3072 µm²|

## Static Timing Analysis (OpenSTA)

### Scenario 1: Ideal Timing

Clock period constraint:

```
10 ns
```

No input/output timing constraints applied.

| Metric | Value |
|--------|-------:|
| Clock Period | 10 ns |
| Worst Slack | 9.28 ns |
| Estimated Critical Path | 0.72 ns |
| Estimated Fmax | ~1.39 GHz |

### Scenario 2: Constrained Timing

Timing constraints:
```
Input Delay = 1 ns
Output Delay = 1 ns
Clock Period = 10 ns
```
| Metric | Value |
|--------|-------:|
| Clock Period | 10 ns |
| Worst Slack | 8.59 ns |
| Estimated Critical Path | 1.41 ns |
| Estimated Fmax | ~709 MHz |

## Timing Comparison

| Scenario | Worst Slack (ns) | Estimated Fmax |
|----------|-----------------:|---------------:|
| Ideal STA | 9.28 | ~1.39 GHz |
| Constrained STA | 8.59 | ~709 MHz |

## Power Analysis

Operating Frequency: **100 MHz** (10 ns clock period)

| Metric | Value |
|--------|-------:|
| Total Power | 39.8 µW |
