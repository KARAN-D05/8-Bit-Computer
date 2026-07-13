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

## Baseline Performance Analysis

| Benchmark | Workload | Dynamic Instructions | Clock Cycles | CPI |
|-----------|----------|---------------------|-------------|----|
| Maximum | A > B | 7 | 17 | 2.4286 |
| Maximum | B > A | 6 | 15 | 2.5000 |
| Multiplication | 10 × 5 | 67 | 170 | 2.5373 |
| Multiplication | 10 × 64 | 834 | 2117 | 2.5383 |
| Multiplication | 10 × 255 | 3317 | 8420 | 2.5384 |
| Matrix Multiplication | M = 1 | 125 | 314 | 2.5120 |
| Matrix Multiplication | M = 64 | 6677 | 16442 | 2.4625 |
| Matrix Multiplication | M = 255 | 26541 | 65338 | 2.4617 |

## Analytical Performance Models

The execution cost of each benchmark was analytically derived by manually tracing the instruction flow and counting dynamic instructions (DI) and clock cycles (CC). The resulting models were validated against RTL simulation.

### Maximum of Two Numbers

| Case | Dynamic Instructions | Clock Cycles | CPI |
|------|---------------------|-------------|----|
| A > B | 7 | 17 | 2.4286 |
| B > A | 6 | 15 | 2.5000 |

The `A > B` execution path performs one additional unconditional `JMP`, requiring two extra clock cycles despite exhibiting a slightly lower CPI.

### Unsigned Multiplication

Let **M** denote the multiplier (loop count).

```text
DI(M)  = 13M + 2
CC(M)  = 33M + 5
CPI(M) = (33M + 5)/(13M + 2)

Steady-State CPI:
lim M→∞ CPI(M) = 33/13 ≈ 2.5385
```

### 2×2 Matrix Multiplication

Let **M** denote the common workload parameter where:

```text
A = B = C = D = M
```

The remaining matrix elements (`E`, `F`, `G`, `H`) influence only the numerical result and do not affect execution time.

```text
DI(M)  = 104M + 21
CC(M)  = 256M + 58
CPI(M) = (256M + 58)/(104M + 21)

Steady-State CPI:
lim M→∞ CPI(M) = 256/104 ≈ 2.4615
```

### Architectural Observation
- Although the matrix multiplication benchmark is implemented using repeated-addition multiplication, its steady-state CPI is lower than the standalone multiplication benchmark. This is because the multiplication loops in matrix multiplication use immediate addressing to load the decrement constant (`LOAD B 0x01`) rather than loading it from memory (`LDB <addr>`). Eliminating one memory access per iteration reduces the loop execution cost from **33M** to **32M** clock cycles, demonstrating the performance advantage of immediate addressing in memory-intensive workloads.
- Overall CPI is a weighted average of the CPI of each execution phase, with the weights determined by the dynamic instruction mix. As the workload increases, the loop dominates the instruction mix, so the overall CPI always converges toward the loop CPI; whether it moves upward or downward depends on whether the loop CPI is greater or less than the initialization CPI.

# Performance Analysis of MAR Optimization

The baseline processor employed a Memory Address Register (MAR), requiring all memory instructions to execute in **3 T-states**. The optimized architecture removes the MAR by directly interfacing `IR[7:0]` with the RAM address bus, reducing every memory instruction to **2 T-states** while preserving ISA compatibility and functional correctness.

## Experimental Results

### Maximum of Two Numbers

| Case | Original CC | Optimized CC | Cycles Saved | Speedup | Execution Time Reduction |
|------|------------|-------------|-------------|---------|-------------------------|
| A > B | 17 | 14 | 3 | 1.214× | 17.65% |
| B > A | 15 | 12 | 3 | 1.250× | 20.00% |

### Unsigned Multiplication

| Workload | Multiplier (M) | Original CC | Optimized CC | Cycles Saved | Speedup | Execution Time Reduction |
|---------|---------------|------------|-------------|-------------|---------|-------------------------|
| Small | 5 | 170 | 134 | 36 | 1.269× | 21.18% |
| Medium | 64 | 2117 | 1668 | 449 | 1.269× | 21.21% |
| Maximum | 255 | 8420 | 6634 | 1786 | 1.269× | 21.21% |

### 2×2 Matrix Multiplication

| Workload | M | Original CC | Optimized CC | Cycles Saved | Speedup | Execution Time Reduction |
|---------|--|------------|-------------|-------------|---------|-------------------------|
| Small | 1 | 314 | 250 | 64 | 1.256× | 20.38% |
| Medium | 64 | 16442 | 13354 | 3088 | 1.231× | 18.78% |
| Maximum | 255 | 65338 | 53082 | 12256 | 1.231× | 18.75% |

# Analytical Validation

## Multiplication

Baseline analytical model:

```text
CC(M) = 33M + 5
DI(M) = 13M + 2
```

Optimized model:

```text
CC(M) = 26M + 4
DI(M) = 13M + 2
```

Since every instruction now executes in exactly **2 T-states**,

```text
CPI(M) = (26M + 4)/(13M + 2) = 2
```

for every workload.

## Matrix Multiplication

Baseline analytical model:

```text
CC(M) = 256M + 58
DI(M) = 104M + 21
```

Optimized model:

```text
CC(M) = 208M + 42
DI(M) = 104M + 21
```

Again,

```text
CPI(M) = (208M + 42)/(104M + 21) = 2
```

for every workload.

# Validation using Amdahl's Law

Amdahl's Law states that the execution time after an optimization is

```text
Execution Time(after)
=
(Execution Time affected / Amount of Improvement)
+
Execution Time unaffected
```

where

- Execution Time affected is the portion accelerated by the optimization.
- Amount of Improvement(k) is the speedup of the accelerated portion.
- Execution Time unaffected remains unchanged.

For this optimization,

```text
k = 3/2 = 1.5
```

since every memory instruction was reduced from **3 T-states** to **2 T-states**.

## Recovering Instruction Composition from the Analytical Model

Rather than manually counting instructions, the analytical models themselves encode the instruction composition of each benchmark.

### Multiplication

Per loop iteration,

Original:

```text
3x + 2y = 33
```

Optimized:

```text
2x + 2y = 26
```

where

- x = memory instructions (3 T-states)
- y = non-memory instructions (2 T-states)

Subtracting the equations,

```text
x = 7
```

Substituting,

```text
y = 6
```

Hence each loop iteration consists of

- 7 memory instructions
- 6 non-memory instructions

Therefore,

Affected execution time:

```text
7 × 3 = 21 cycles
```

Unaffected execution time:

```text
6 × 2 = 12 cycles
```

Applying Amdahl's Law,

```text
Execution Time(after)

=
21/1.5 + 12

=
14 + 12

=
26 cycles
```

which exactly matches the optimized analytical model.

Likewise,

```text
Speedup

=
33/26

=
1.269×
```

matching both simulation and experimental measurements.

### Matrix Multiplication

Per workload unit,

Original:

```text
3x + 2y = 256
```

Optimized:

```text
2x + 2y = 208
```

Subtracting,

```text
x = 48
```

Substituting,

```text
y = 56
```

Therefore,

Affected execution time:

```text
48 × 3 = 144 cycles
```

Unaffected execution time:

```text
56 × 2 = 112 cycles
```

Applying Amdahl's Law,

```text
Execution Time(after)

=
144/1.5 + 112

=
96 + 112

=
208 cycles
```

again exactly matching the optimized analytical model.

Likewise,

```text
Speedup

=
256/208

=
1.231×
```

which matches simulation and experimental measurements.

# Observations

- Removing the Memory Address Register reduced every memory instruction from **3 T-states** to **2 T-states**, resulting in a uniform **2 T-state instruction execution** across the ISA.
- Dynamic instruction count remained unchanged; only instruction latency was reduced.
- Consequently, the optimized processor exhibits a constant **CPI = 2** for both multiplication and matrix multiplication, independent of workload.
- The analytical performance models exactly predicted the experimentally measured execution times for every benchmark and workload.
- Solving the system of linear equations derived from the analytical models recovered the dynamic instruction composition of each benchmark without manually counting instructions.
- Both forms of Amdahl's Law (execution-time form and speedup form) independently reproduced the optimized execution-time models, providing an additional validation of the analytical models and architectural optimization.
- The absolute number of clock cycles saved increased dramatically with workload, experimentally demonstrating Amdahl's principle that optimizations affecting frequently executed portions of a program provide increasingly larger absolute performance gains.
- Although matrix multiplication is composed of repeated multiplication kernels, it achieves a lower relative speedup (≈1.231×) than standalone multiplication (≈1.269×). This is because a smaller fraction of its total execution time is spent executing memory instructions, reducing the proportion of execution affected by the optimization.
