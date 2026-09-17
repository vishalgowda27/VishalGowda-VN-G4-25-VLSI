# 32-bit RV32I 5-Stage Pipelined RISC-V Processor

A 32-bit RISC-V RV32I processor designed using Verilog HDL with a 5-stage pipeline:

**IF → ID → EX → MEM → WB**

## Features

- 32-bit RV32I architecture
- 5-stage pipelining
- 37 supported instructions
- ALU, Register File and Memory
- Data Forwarding
- Hazard Detection
- JAL and JALR support
- Verilog testbench
- Simulation using Icarus Verilog / Verilator
- Waveform verification using GTKWave

## Architecture

```text
IF → ID → EX → MEM → WB
     │     │     │
   Decode  ALU  Memory
Tools
Verilog HDL
Icarus Verilog
Verilator
GTKWave
VS Code
Outcome

Successfully implemented and functionally verified a 32-bit RV32I 5-stage pipelined RISC-V processor.

Future Scope
FPGA implementation
Branch Prediction
BTB
Cache Memory
Larger RISC-V programs
