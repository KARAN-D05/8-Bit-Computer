# Computer Organization

The processor follows a **Harvard architecture** with physically separate instruction and data memories. Instruction fetch, memory addressing, computation, and control are organized into dedicated datapaths, while data movement between computational units is performed through a centralized multiplexer-based internal data bus.

The architecture separates instruction flow from data flow, allowing a clean and modular organization that closely follows synchronous register-transfer principles.

## Architectural Overview

* Harvard Architecture
* 8-bit Data Width
* 16-bit Instruction Width
* 256 × 16 Program ROM
* 256 × 8 Data RAM
* Hardwired Control Unit
* Multiplexer-Based Internal Data Bus
* Dedicated Instruction Path
* Dedicated Address Path
* Dedicated Control Path

## Instruction Path

Instruction fetch is completely isolated from the internal data bus.

The Program Counter continuously supplies the instruction address to the Program ROM. The ROM outputs a 16-bit instruction which is captured by the Instruction Register during the Fetch cycle.

```
Program Counter
      │
      ▼
 Program ROM
      │
      ▼
Instruction Register
```

Because the Program ROM is continuously addressed by the Program Counter, instruction fetch requires only the Instruction Register load signal together with Program Counter increment during the Fetch T-State.

## Address Path

Memory addressing is handled through a dedicated address path independent of the internal data bus.

The lower byte of the Instruction Register contains either an immediate operand or a memory address. During memory instructions, this address is loaded into the Memory Address Register, which continuously supplies the address input of the Data RAM.

```
Instruction Register[7:0]
          │
          ▼
 Memory Address Register
          │
          ▼
       Data RAM
```

Separating address generation from the data bus simplifies memory operations while maintaining a deterministic execution sequence.

## Data Path

Data movement between computational units is performed through an internal **8-bit multiplexer-based data bus**.

Unlike a traditional single-bus architecture, only modules capable of producing data participate in the internal bus.

Current bus sources are:

* Register A
* Register B
* ALU Output
* Data RAM Output
* Instruction Register Operand (`IR[7:0]`)

The Control Unit selects exactly one source using the 3-bit `Bus_Select` field.

```
                +----------------+
Register A ---->|                |
Register B ---->|                |
ALU Output ---->|  Bus MUX       |----> Internal Data Bus
RAM Output ---->|                |
IR Operand ---->|                |
                +----------------+
```

The internal data bus is then used to transfer data into the destination register or RAM during the next clock edge.

This organization avoids electrical contention while providing a simple and scalable mechanism for register transfers.

## Arithmetic Datapath

Arithmetic and logical operations are performed using dedicated operand paths.

Registers A and B continuously drive the ALU inputs.

```
Register A ----\
                \
                 ---> ALU ----> Bus MUX
                /
Register B ----/
```

The ALU output becomes one of the selectable internal bus sources, allowing arithmetic results to be written back into Register A or other destination modules.

## Flag Path

Processor status information is maintained through a dedicated flag path.

The ALU continuously generates status flags which are stored inside the Flag Register whenever the Control Unit asserts the Flag Register load signal.

```
ALU
 │
 ▼
Flag Register
 │
 ▼
Control Unit
```

The Control Unit directly evaluates these flags during conditional branch instructions.

## Control Organization

The Control Unit receives:

* Current Opcode
* Current T-State
* Processor Flags

and generates the complete processor control word consisting of:

* Register Load Signals
* Program Counter Control
* Memory Write Control
* ALU Operation Select
* Bus Source Select
* T-State Counter Clear

Every instruction begins with a universal Fetch cycle followed by instruction-specific execution states.

The Control Unit terminates an instruction by asserting `TC_clear` during the final execution T-State, returning execution to the Fetch state for the next instruction.
