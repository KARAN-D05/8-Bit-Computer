# 🏗️ 8-Bit Computer  

<p align="center">
  <img src="System_Integration/Images/System-Integration.png" 
       width="1200"/>
  <br>
  <sub></b> ⚙️ System Integration - Registers, Memory, ALU, Program Counter and Display Connected
</p>

## 🧠 About  
- This project is my attempt to explore how computers work **fundamentally at the gate level**.  
I aim to design and build a fully functional 8-bit CPU from scratch.  

## 🎯My Approach: 
- Before simulation, each module is designed conceptually using hand-drawn block diagrams and written reasoning to validate the logic flow through mental simulation and small example cases.
- The block diagram is then refined into a rough structural, gate-level representation before being implemented, debugged, and rigorously tested in digital logic simulators such as Logisim Evolution and Falstad.
- Where possible, I explore multiple design approaches to achieve the same functionality, comparing behavior, complexity, and design trade-offs before finalizing an implementation. 

## ⚙️ Implementation Stack
![Verilog](https://img.shields.io/badge/Verilog-FFEA00?style=for-the-badge&logoColor=black)
![Logisim Circuits](https://img.shields.io/badge/Logisim%20Circuits-00C853?style=for-the-badge)

## ✅ Modules Validated  
- [Clock Module](CLOCK)
- [Registers](registers_AND_bus)  
- [Bus System](registers_AND_bus)
- [ALU](ALU)
- [RAM](RAM)
- [Address Decode Logic](Address_Decoders)
- [Manually Programmable RAM](Manually_Programmable_RAM)
- [Programmable_RAM_Stored Program Execution](Programmable_RAM(StoredProgramExecution))
- [Program Counter](Program_Counter)
- [Programmable ROM - Hex Display](PROM_Chip-Hex-Display)
- [Programmable ROM - Decimal Display](PROM_Chip-Decimal-Display)
- [System Integration](System_Integration)
- [Stored Micro-Program Control](Stored_Program_Control)
  
<p align="center">
  <img src="registers_AND_bus/images/registers_AND_bus.png" 
       width="850"/>
  <br>
  <sub><b>💾 Registers & Bus System </b></sub>
</p>

## 🔍 Verilog Implementations
- [Clock](CLOCK/CLOCK-Verilog)
- [Set-Only Latch](registers_AND_bus/Verilog)

<p align="center">
  <img src="CLOCK/CLOCK-Verilog/Clock-Module/images/waveform.png" 
       width="2000"/>
  <br>
  <sub></b> Clock Module
</p>

## 📂 Project Structure  
Each module will have its own folder containing:  
- A dedicated **README.md** explaining design, features, and usage  
- **Images** of schematics, simulations, and hardware builds  

## 🎯 Goals  
- Understand computation from the ground up  
- Document the full design and build process  
- Share schematics, notes, and experiments for others to learn from

## 📜 License
- Source code, HDL, and Logisim circuit files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).
