# 8Bit-Computer-rtl
A parameterized 8-bit stored-program computer designed from the RTL level in Verilog. The processor follows a **Harvard architecture** with separate program and data memories, a custom Instruction Set Architecture (ISA), a **hardwired control unit**, and a **multiplexer-based internal data bus** for datapath communication.

## 🛠️ Tools & Technologies
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-Simulation-1E88E5?style=flat-square)
![Verilator](https://img.shields.io/badge/Verilator-Linting-00897B?style=flat-square)
![Cocotb](https://img.shields.io/badge/Cocotb-Verification-D81B60?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-Waveforms-F57C00?style=flat-square)
![Yosys](https://img.shields.io/badge/Yosys-Synthesis-43A047?style=flat-square)
![OpenSTA](https://img.shields.io/badge/OpenSTA-Static_Timing_Analysis-8E24AA?style=flat-square)

## 🧩 System Organization
<p align="center">
  <img src="Computer/images/Computer_org.png" width="800"/>
</p>

## 📚 Documentation
- [Instruction Set Architecture](ISA.md)
- [Computer Organization](Organization.md)

## Maximum of Two Numbers

This program compares two unsigned 8-bit values stored in RAM address `0x08` and `0x09` and writes the larger value back to RAM address `0x0A`. It demonstrates arithmetic, conditional branching, memory operations, and program control using the processor's custom instruction set.

`Max.asm`

```asm
; Program: Maximum of Two Numbers

LDA 0x08        ; Load first number
LDB 0x09        ; Load second number

SUB             ; Compute A - B
JN  STORE_B     ; If A < B, branch to store second number

LDA 0x08        ; Restore first number
STA 0x0A        ; Store first number as maximum
JMP END         ; Skip alternate path

STORE_B:
STB 0x0A        ; Store second number as maximum

END:
HLT             ; End program
```

Demonstrates data movement (`LDA, LDB, STA, STB`), ALU computation (`SUB`), flag-based control flow (`JN`), program control (`JMP`), and processor termination (`HLT`).

> The waveform captures the branch-taken execution path, where the processor skips the alternate instruction sequence after evaluating the Negative flag, demonstrating conditional control flow.

<p align="center">
  <img src="Computer/images/max_waveform.png" width="1000"/>
  <br>
  <sub>RTL simulation of the processor executing the Maximum of Two Numbers program, illustrating instruction fetch, ALU computation, memory operations, and control flow.</sub>
</p>

## 🔬 Physical Characterization

The following table summarizes post-synthesis implementation results obtained using the Sky130 HD standard-cell library.
Timing results correspond to constrained static timing analysis using a 10 ns clock period, 1 ns input delay, and 1 ns output delay.

> Technology: Sky130HD

| Module | Estimated Area | Critical Path | Estimated Fmax | Estimated Total Power|
| ---------- | ---------- | ---------- | ---------- | ---------- |
| [General Purpose Registers](Register) | 320.3072 µm² | 1.41 ns | ~709 MHz | 39.8 µW |
| [Arithmetic and Logic Unit](ALU) | 877.0912 µm² |3.21 ns | ~311 MHz | 349 µW |
| [Program Counter](PC) | 444.176 µm² | 1.78 ns | ~561.79 MHz | 48.1 µW |
| [ROM (256x8)](ROM) | 2277.184 µm² | 2.85 ns | ~351 MHz | 888 µW |
| [RAM (256x8)](RAM) | 75862.7584 µm² | 5.18 ns | ~208 MHz | 9.88 mW |
| [Memory Address Register](MAR) | 320.3072 µm² | 1.41 ns | ~709 MHz | 39.8 µW |
| [Flags Register](FR) | 200.192 µm² | 1.41 ns | ~709 MHz | 24.9 µW |
| [Instruction Register](IR) | 640.6144 µm² | 1.41 ns | ~709 MHz | 79.7 µW |
| [T-State Counter](TC) | 125.12 µm² | 1.38 ns | ~725 MHz | 15.6 µW |
| [Control Unit](CU) | 359.0944 µm² | 2.29 ns | ~437 MHz | 41.4 µW |
| [Computer](Computer) | 80347.06 µm² | 25.55 ns | ~39 MHz | 8.67 mW |

> Note: The reported RAM area and timing correspond to a behavioral Verilog memory synthesized entirely using Sky130 HD standard cells. Since no dedicated SRAM macro was used, the memory is implemented using flip-flops and associated decode/multiplexing logic, making it the dominant contributor to overall chip area and critical path delay.

## ⚙️ Implemented Modules

| Module               | Description                                         | Status |
| -------------------- | --------------------------------------------------- | ------ |
| ALU                  | Arithmetic and logical operations with status flags | ✅     |
| A Register           | Loadable general-purpose register                   | ✅     |
| B Register           | Loadable general-purpose register                   | ✅     |
| Program Counter      | Instruction address generation                      | ✅     |
| ROM                  | Program storage subsystem                           | ✅     |
| RAM                  | Data storage subsystem                              | ✅     |
| Memory Address Register | Stores RAM address that needs to be accessed     | ✅     |
| Flags Register       | Stores status flags of computation                  | ✅     |
| Instruction Register | Stores current instruction                          | ✅     |
| T-State Counter      | Tracks the T-state of an instruction                | ✅     |
| Control Unit         | Generates control signals                           | ✅     |

## ⬇️ Download This Repository

### 🪟 Windows
Download → [download_repos.bat](./download_repos.bat)
``` 
Double-click it and pick the repo(s) you want.
```

### 🐧 Linux / macOS
Download → [download_repos.sh](./download_repos.sh)
```
bash

chmod +x download_repos.sh
./download_repos.sh
```

> Always downloads the latest version.

## 📜License
- Source code and HDL files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).
