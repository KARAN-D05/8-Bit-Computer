# 8Bit-Computer-rtl

## 🛠️ Tools & Technologies
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-Simulation-1E88E5?style=flat-square)
![Verilator](https://img.shields.io/badge/Verilator-Linting-00897B?style=flat-square)
![Cocotb](https://img.shields.io/badge/Cocotb-Verification-D81B60?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-Waveforms-F57C00?style=flat-square)
![Yosys](https://img.shields.io/badge/Yosys-Synthesis-43A047?style=flat-square)
![OpenSTA](https://img.shields.io/badge/OpenSTA-Static_Timing_Analysis-8E24AA?style=flat-square)

## 🔬 Physical Characterization

The following table summarizes post-synthesis implementation results obtained using the Sky130 HD standard-cell library.
Timing results correspond to constrained static timing analysis using a 10 ns clock period, 1 ns input delay, and 1 ns output delay.

> Technology: Sky130HD

| Module | Area | Worst Slack | Estimated Fmax | Total Power @ 100 MHz |
| ---------- | ---------- | ---------- | ---------- | ---------- |
| General Purpose Register | 320.3072 µm² | 8.59 ns | ~709 MHz | 39.8 µW |
