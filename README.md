# Single Cycle RISC-V CPU

> ⚠️ **Disclosure:** This project is currently based on an online tutorial. It serves as a learning foundation — the goal is to extend it significantly with original features over time (see [Future Plans](#future-plans)).

---

## Overview

A single-cycle RISC-V CPU implementation in SystemVerilog. Each instruction completes fully within one clock cycle — fetch, decode, execute, memory access, and write-back all happen in a single pass. It targets a subset of the RV32I base integer instruction set.

---

## How It Works

The CPU follows the classic single-cycle datapath:

1. **Fetch** — The Program Counter (PC) indexes into instruction memory, returning a 32-bit instruction each cycle.
2. **Decode** — The instruction is split into opcode, registers, and immediate fields. The Control Unit interprets the opcode and `funct3`/`funct7` fields to assert the appropriate control signals.
3. **Execute** — The ALU performs arithmetic or logical operations on register values or sign-extended immediates.
4. **Memory** — For load/store instructions, the data memory is read from or written to using the ALU-computed address.
5. **Write-back** — A result (from ALU, memory, or PC+4 for jumps) is written back to the destination register.
6. **PC Update** — The next PC is either PC+4 (sequential) or a branch/jump target computed as PC + immediate.

---

## Modules

| Module | File | Description |
|---|---|---|
| `SingleCycleCPU` | `SingleCycleCPU.sv` | Top-level: wires all components together, holds the PC register |
| `ControlUnit` | `controlUnit.sv` | Decodes opcode/funct3/funct7 into control signals; computes `pc_source` |
| `ALU` | `ALU.sv` | Performs ADD, SUB, AND, OR based on 3-bit `alucontrol` |
| `Registers` | `Registers.sv` | 32×32-bit register file; async read, sync write; x0 hardwired to zero |
| `Memory` | `Memory.sv` | Shared 64-word memory used for both instruction and data; word-aligned |
| `SignExtension` | `SignExtension.sv` | Sign-extends immediates for I, S, B, J, and U instruction formats |
| `core_pkg` | `core_pkg.sv` | SystemVerilog package defining opcode and ALU op enumerations |

---

## Supported Instructions

| Type | Instructions |
|---|---|
| R-Type | `ADD`, `SUB`, `AND`, `OR` |
| I-Type ALU | `ADDI`, `ANDI`, `ORI` |
| I-Type Load | `LW` |
| S-Type | `SW` |
| B-Type | `BEQ` |
| J-Type | `JAL` |
| U-Type | `LUI`, `AUIPC` (partial) |

---

## Strengths

- Clean, readable SystemVerilog with a sensible module hierarchy
- Proper handling of `x0` as a hardwired zero register
- Control signals are fully derived from the opcode — no hardcoded instruction logic in the datapath
- Package file (`core_pkg`) keeps opcode definitions organized and reusable
- Word-aligned memory with reset support

---

## Known Issues & Gaps

- **ALU subtraction bug** — `source1 - (~source2 + 1)` double-applies two's complement; it should simply be `source1 - source2`
- **No `JALR` support** — The `JALR` opcode (`7'b1100111`) is defined in `core_pkg` but unhandled in the Control Unit
- **Syntax error in Control Unit** — `7'bb0010111` is an invalid literal in the `auipc`/`lui` case
- **`write_back_source` mismatch** — Load instruction sets `2'b01` (ALU result) but should be `2'b00` (memory); this is inverted
- **`second_add_source` unconnected** — Declared in the Control Unit but never wired in the top-level
- **`SLT` (Set Less Than)** — `alu_control = 3'b101` is emitted but the ALU has no case for it; defaults to zero
- **No testbench** — `test_imemory.hex` is empty; there is no simulation infrastructure yet
- **Shared instruction/data memory** — Both use the same `Memory` module but are separate instances, so there is no true unified memory map
- **No hazard handling** — Not applicable for single-cycle, but worth noting before any pipeline work begins

---

## Future Plans

This project will move well beyond the tutorial baseline. Planned extensions:

- **Pipelining** — Refactor into a classic 5-stage pipeline (IF → ID → EX → MEM → WB) with forwarding and hazard detection
- **Branch Prediction** — Add a branch predictor (starting with 2-bit saturating counters) to reduce branch penalties in the pipeline
- **Full RV32I Compliance** — Implement remaining instructions (`JALR`, `SLTI`, `SLTIU`, `XORI`, `SRLI`, `SRAI`, `SLTU`, etc.)
- **Floating Point Support** — Explore RV32F extension with a dedicated FPU for single-precision operations
- **Proper Testbench** — Build a self-checking testbench with a RISC-V assembly test suite
- **Unified Memory Map** — Replace the dual-memory setup with a proper instruction/data split and address decoder

---

## Project Structure

```
SingleCycleCPU.srcs/sources_1/new/
├── SingleCycleCPU.sv     # Top-level CPU
├── controlUnit.sv        # Control unit & ALU decoder
├── ALU.sv                # Arithmetic Logic Unit
├── Registers.sv          # Register file
├── Memory.sv             # Instruction & data memory
├── SignExtension.sv      # Immediate sign extension
├── core_pkg.sv           # Shared type definitions
└── test_imemory.hex      # (Empty) instruction memory init file
```
