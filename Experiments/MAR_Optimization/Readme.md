# Memory Address Register (MAR) Optimization Study

## Motivation

While studying *Computer Organization and Design* by Patterson & Hennessy, I encountered **Amdahl's Law**, which states that the overall performance improvement obtained from an optimization depends on the fraction of execution time affected by that optimization.

This prompted the following question:

> **Can the Memory Address Register (MAR) be removed from my multi-cycle processor without affecting correctness, and if so, how much performance improvement does it provide?**

The completed 8-bit processor serves as an experimental platform to quantitatively evaluate this architectural modification.

## Background

In the original processor, memory instructions require an additional T-state to load the Memory Address Register before accessing RAM.

Original memory access sequence:

```
Fetch
 ↓
MAR ← IR[7:0]
 ↓
RAM Access
```

Since memory operands are encoded directly within the instruction, the MAR may be unnecessary. The proposed optimization directly connects the instruction operand (`IR[7:0]`) to the RAM address bus.

Optimized memory access sequence:

```
Fetch
 ↓
RAM Access ← IR[7:0]
```

This removes one T-state from every memory-related instruction.

## Hypothesis

Removing the Memory Address Register should:

- Reduce the CPI of memory-related instructions.
- Improve execution time for memory-intensive workloads.
- Produce little improvement for programs containing relatively few memory operations.

According to **Amdahl's Law**, workloads spending more execution time performing memory accesses should experience greater overall speedup.

## Methodology

The following modifications will be implemented:

- Remove the Memory Address Register.
- Directly connect `IR[7:0]` to the RAM address input.
- Update the Control Unit to remove the MAR load state.
- Verify functional correctness using existing Cocotb verification infrastructure.
- Re-run logic synthesis and static timing analysis.

## Benchmarks

The optimized processor will be evaluated using existing software benchmarks.

| Benchmark | Purpose |
|-----------|---------|
| Maximum of Two Numbers | Minimal memory activity |
| Unsigned Multiplication | Moderate memory activity |
| 2×2 Matrix Multiplication | Memory-intensive workload |

For each benchmark the following metrics will be collected:

- Total clock cycles
- CPI
- Execution time
- Measured speedup

## Expected Observation

The **Maximum** benchmark is expected to exhibit minimal performance improvement because relatively few instructions perform memory accesses.

The **Multiplication** benchmark should show moderate improvement due to repeated memory loads and stores.

The **Matrix Multiplication** benchmark is expected to demonstrate the greatest speedup since memory accesses dominate program execution.

These observations should illustrate the practical implications of **Amdahl's Law**, showing that architectural optimizations provide benefits proportional to the fraction of execution time affected by the optimization.

## Results

*To be completed after implementation*

| Benchmark | Case | Dynamic Instructions | Clock Cycles | Optimized Cycles | Speedup |
|-----------|------|-------------|-------------|-----------------|--------|
| Maximum | A > B | 7 | 17 | | |
| Maximum | B > A | 6 | 15 | | |
| Multiplication | Small Workload: 10 × 5 | 67 | 170 | | |
| Multiplication | Medium Workload: 10 × 64 | 834 | 2117 | | |
| Multiplication | Maximum Workload: 10 × 255 | 3317 | 8420 | | |
| Matrix Multiplication | Small Workload | | | | |
| Matrix Multiplication | Medium Workload | | | | |
| Matrix Multiplication | Maximum Workload | | | | |

## Analytical Performance Models

The execution cost of each benchmark was analytically derived by manually tracing the instruction flow and counting dynamic instructions and clock cycles.

### Maximum of Two Numbers

| Case | Dynamic Instructions | Clock Cycles | CPI |
|------|---------------------:|-------------:|----:|
| A > B | 7 | 17 | 2.4286 |
| B > A | 6 | 15 | 2.5000 |

The `A > B` path executes one additional unconditional jump (`JMP`), resulting in two extra clock cycles despite exhibiting a slightly lower CPI.

### Unsigned Multiplication

Let **M** denote the multiplier (loop count).

**Dynamic Instruction Count**

```text
DI(M) = 13M + 2
```

**Clock Cycles**

```text
CC(M) = 33M + 5
```

**Average CPI**

```text
CPI(M) = (33M + 5) / (13M + 2)
```

**Steady-State CPI**

```text
lim M→∞ CPI(M) = 33 / 13 ≈ 2.5385
```

### 2×2 Matrix Multiplication

Let **M** denote the common workload parameter where the loop-controlling matrix elements satisfy:

```text
A = B = C = D = M
```

The remaining matrix elements affect only the numerical result and do not influence execution time.

**Dynamic Instruction Count**

```text
DI(M) = 104M + 21
```

**Clock Cycles**

```text
CC(M) = 256M + 58
```

**Average CPI**

```text
CPI(M) = (256M + 58) / (104M + 21)
```

**Steady-State CPI**

```text
lim M→∞ CPI(M) = 256 / 104 ≈ 2.4615
```

### Observations

- Both multiplication and matrix multiplication exhibit linear growth in dynamic instruction count and clock cycles with increasing workload.
- The constant terms represent fixed program initialization and termination overhead.
- As the workload increases, the influence of this fixed overhead diminishes and the average CPI converges to a constant value determined by the loop body.
- These analytical models were validated against RTL simulation before evaluating the MAR optimization.

## Discussion

*To be completed after implementation.*

Discussion will include:

- Comparison between predicted and measured speedup.
- Effect of memory intensity on overall performance.
- Architectural trade-offs introduced by removing the MAR.
- Whether the optimization justifies the additional hardware simplification.

## Conclusion

*To be completed after implementation.*
