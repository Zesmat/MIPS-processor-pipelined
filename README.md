# MIPS-Processor-Pipelined

## Overview
This project implements a simple pipelined MIPS processor using VHDL. The design includes solutions for structural and control hazards to ensure efficient execution of instructions. The MIPS architecture, known for its simplicity and efficiency, is enhanced by pipeline stages that allow multiple instructions to be processed simultaneously, improving overall performance.

## Features
- **Pipeline Architecture:** Implements the classic five-stage pipeline: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB).
- **Hazard Detection:** Includes mechanisms to detect and resolve structural and control hazards.
- **Instruction Set:** Supports basic MIPS instructions including MOV, INP, OUT, MUL, BUN, and SKP.
- **Memory Management:** Utilizes separate instruction and data memories to avoid conflicts and improve performance.

## Hazard Solutions

### Structural Hazards
Structural hazards occur when hardware resources are insufficient to support all the instructions in the pipeline. In this design, structural hazards are resolved by:
- **Dual Memories:** Using separate instruction and data memories for the IF and MEM stages, respectively, to allow simultaneous access.
- **Separated Register File Inputs/Outputs:** Ensuring the register file can handle simultaneous read and write operations by separating read operations (during ID stage) from write operations (during WB stage).

### Control Hazards
Control hazards are handled by predicting that branches are not taken. This approach minimizes pipeline stalls and keeps the pipeline flowing smoothly:
- **Branch Prediction:** Assuming that a branch is not taken, allowing the pipeline to continue fetching subsequent instructions.
- **Pipeline Clearing:** If a branch is taken, all pipeline registers are cleared to terminate any instructions that were fetched or decoded after the branch instruction, ensuring correct program execution.

## Design and Implementation

### Key Components
1. **Registers:** A register file with 32 general-purpose 32-bit registers, supporting read and write operations controlled by the control unit.
2. **Instruction Memory:** Stores instructions and allows read operations to fetch instructions for execution.
3. **Data Memory:** Stores data, supporting both read and write operations, used during the MEM stage.
4. **ALU (Arithmetic Logic Unit):** Performs arithmetic and logical operations such as addition, subtraction, multiplication, and logical AND/OR.
5. **Control Unit:** Decodes instruction opcodes and generates control signals for managing data paths and ALU operations, handling sequencing and control of multiplexers and pipeline registers.
6. **Multiplexers (MUX):** Select data paths based on control signals, e.g., choosing between immediate values and register values for ALU operations.
7. **Sign Extender:** Extends the sign of immediate values to match the 32-bit width of the data path for correct arithmetic operations.
8. **Pipeline Registers:** Hold intermediate values between pipeline stages, ensuring data consistency and synchronization.
9. **Adder:** Calculates the next program counter (PC) value, typically incrementing the current PC by 4 to point to the next instruction.
10. **ALU Control:** Generates control signals for the ALU based on the instruction opcode.

### Pipeline Stages
1. **Instruction Fetch (IF):** Fetches the instruction from instruction memory.
2. **Instruction Decode (ID):** Decodes the fetched instruction and reads registers.
3. **Execute (EX):** Performs the operation specified by the instruction using the ALU.
4. **Memory Access (MEM):** Accesses data memory for load/store instructions.
5. **Write Back (WB):** Writes the result back to the destination register.

## Pipeline Cycle Analysis
### Cycle-by-Cycle Explanation
- **Cycle 1 (IF):** The MOV instruction is fetched from instruction memory.
- **Cycle 2 (ID):** The MOV instruction is decoded, and the source and destination registers are read.
- **Cycle 3 (EX):** The MOV operation is executed, and the data is prepared for writing.
- **Cycle 4 (MEM):** The data is accessed if the instruction involves memory.
- **Cycle 5 (WB):** The result is written back to the destination register.

Subsequent instructions enter the pipeline at each cycle, demonstrating parallel execution. For instance, while the MOV instruction is in the ID stage, the next instruction can be in the IF stage.

### Hazard Detection
Hazard detection mechanisms were validated using specific test cases designed to trigger hazards. Data forwarding, stalling, and branch prediction ensured smooth execution without pipeline stalls. Control hazards were resolved by predicting that branches were not taken and clearing the pipeline registers if a branch was taken.

## Testing and Results
- **Component Testing:** Each component was tested individually using VHDL test benches to ensure functionality.
- **Integration Testing:** The complete data path was tested with a program that included various instructions to verify the correct functioning of the pipeline.
- **Hazard Testing:** Scenarios causing data and control hazards were introduced to validate the effectiveness of the hazard detection and resolution mechanisms.

## Conclusion
This project successfully implemented a pipelined MIPS processor using VHDL, demonstrating the principles of pipeline architecture and hazard detection. The design effectively handled structural and control hazards, ensuring efficient instruction execution. The project provided valuable insights into the complexities of processor design and the benefits of pipeline processing.

## Design Overview
![mips  3](https://github.com/mha66/MIPS-processor-pipelined/assets/123664862/82e85e6a-82a5-48a6-b66f-76feca8f5bbb)
