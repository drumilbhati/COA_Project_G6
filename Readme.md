# RISC Processor Implementation

## Project Overview

A RISC (Reduced Instruction Set Computing) processor implementation in Verilog with a complete instruction set, I/O capabilities, and memory management.

## Features

- 8-bit data path
- 25-bit instruction format
- 16 general-purpose registers
- Hardware components:
  - ALU (Arithmetic Logic Unit)
  - Program Counter
  - Register File
  - SRAM
  - Stack
  - I/O Ports
  - Instruction Memory

## Port Addresses

### Input Ports (IN)

- Port 1: 0xF1 (11110001)
- Port 2: 0xF2 (11110010)
- Port 3: 0xF3 (11110011)
- Port 4: 0xF4 (11110100)

### Output Ports (OUT)

- Port 1: 0xF8 (11111000)
- Port 2: 0xF9 (11111001)
- Port 3: 0xFA (11111010)
- Port 4: 0xFB (11111011)

## Instruction Format

```
24:20 - Opcode   (5 bits)
19:16 - Destin   (4 bits)
15:12 - Source1  (4 bits)
11:8  - Source2  (4 bits)
7:0   - Imm      (8 bits)
```

## Key Components

1. **ALU Operations**

   - Addition/Subtraction
   - Logical operations (AND, OR, XOR)
   - Shift operations
   - Compare operations

2. **Memory Operations**

   - SRAM read/write
   - Stack push/pop
   - Register file access

3. **Control Logic**

   - 5-phase timing generation
   - Instruction decode
   - Control signal generation

4. **I/O System**
   - 4 input ports
   - 4 output ports
   - Memory-mapped I/O

## File Structure

- `RISC_Processor.v` - Main processor module
- `subcomponents.v` - Individual component modules
- `RISC_Processor_tb.v` - Testbench
- `ROM.txt` - Instruction memory content

## Usage

1. Compile the Verilog files:

```bash
iverilog -o processor RISC_Processor.v RISC_Processor_tb.v
```

2. Run simulation:

```bash
vvp processor
```

3. View waveforms:

```bash
gtkwave Wavedump.vcd
```

## Testing

The testbench includes:

- Reset sequence
- Basic ALU operations
- Memory operations
- I/O operations
- Control flow instructions

## Requirements

- Verilog simulator (e.g., Icarus Verilog)
- Waveform viewer (e.g., GTKWave)
