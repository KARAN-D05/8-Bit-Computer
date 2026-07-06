# Experiments
This folder records architectural experiments performed on the completed 8-bit processor. The objective is not to redesign the processor, but to investigate the quantitative effect of a specific microarchitectural optimization inspired by concepts studied in Computer Organization and Design by David A. Patterson and John L. Hennessy.

## Optimizations
[MAR Optimization](MAR_Optimization): 
- This experiment investigates the impact of removing the Memory Address Register (MAR) by directly interfacing `IR[7:0]` with the RAM address bus. Eliminating the MAR load stage reduces memory instructions from 3 T-states to 2, increasing the proportion of the ISA executing in 2 T-states from **84% to 100%**.
- The objective is to quantify the resulting performance improvement on representative workloads and validate **Amdahl's Law** by comparing the measured speedup across programs with different memory-access intensities, such as Maximum of Two Numbers, Unsigned Multiplication and 2×2 Matrix Multiplication.
