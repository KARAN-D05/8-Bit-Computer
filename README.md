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

| Module | Area | Critical Path Delay | Estimated Fmax | Estimated Total Power @ 100MHz |
| ---------- | ---------- | ---------- | ---------- | ---------- |
| [General Purpose Registers](Register) | 320.3072 µm² | 1.41 ns | ~709 MHz | 39.8 µW |
| [Arithmetic and Logic Unit](ALU) | 877.0912 µm² |3.21 ns | ~311 MHz | 349 µW |
| [Program Counter](PC) | 391.6256 µm² | 1.36 ns | ~735.29 MHz | 44.2 µW |

<p align="center">
  <img src="ALU/images/alu_waveform.png" width="800"/>
  <br>
  <sub>ALU performing arithmetic & logical operations</sub>
</p>

## ⚙️ Implemented Modules

| Module               | Description                                         | Status |
| -------------------- | --------------------------------------------------- | ------ |
| ALU                  | Arithmetic and logical operations with status flags | ✅     |
| A Register           | Loadable general-purpose register                   | ✅     |
| B Register           | Loadable general-purpose register                   | ✅     |
| Program Counter      | Instruction address generation                      | ✅     |
| RAM                  | Data storage subsystem                              | ⏳     |
| Instruction Register | Stores current instruction                          | ⏳     |
| Control Unit         | Generates control signals                           | ⏳     |
