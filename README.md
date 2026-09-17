# 32-bit RV32I 5-Stage Pipelined RISC-V Processor

A modular **32-bit RISC-V RV32I processor** designed and implemented using **Verilog HDL**. The processor follows a classical **5-stage pipelined architecture** consisting of Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB).

## 🚀 Features

- 32-bit RV32I processor architecture
- 5-stage pipeline: **IF → ID → EX → MEM → WB**
- Modular Verilog HDL design
- Support for **37 RV32I instructions**
- R-type and I-type ALU instructions
- Load and Store instructions
- Conditional Branch instructions
- JAL and JALR jump instructions
- LUI and AUIPC instructions
- IF/ID, ID/EX, EX/MEM and MEM/WB pipeline registers
- Data forwarding for pipeline dependencies
- Hazard detection and handling
- ALU supporting arithmetic, logical, shift and comparison operations
- Verilog-based testbench
- Functional simulation and waveform verification using **GTKWave**

## 🏗️ Processor Architecture

```text
             Instruction Memory
                    │
                    ▼
              ┌───────────┐
              │    IF     │
              └─────┬─────┘
                    │
                 IF/ID
                    │
                    ▼
              ┌───────────┐
              │    ID     │
              └─────┬─────┘
                    │
                 ID/EX
                    │
                    ▼
              ┌───────────┐
              │    EX     │
              │    ALU    │
              └─────┬─────┘
                    │
                EX/MEM
                    │
                    ▼
              ┌───────────┐
              │    MEM    │
              │ Data Mem  │
              └─────┬─────┘
                    │
                MEM/WB
                    │
                    ▼
              ┌───────────┐
              │    WB     │
              └─────┬─────┘
                    │
                    ▼
               Register File
