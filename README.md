# MIPS-processor-pipelined
## Pipelined MIPS with Structural and Control hazards solved 
### Structural Hazards
Solved by: 
* using two memories: data memory and instruction memory for MEM and IF stages respectively.
* seperating the write inputs of the register file from the read inputs and outputs such that reading only happens in ID stage, and writing in WB stage.
### Control Hazards
Solved by predicting that a branch is not taken
- if a branch is not taken, the stages will continue operarting normally.
- if a branch is taken, all the pipeline registers will be cleared thus terminating any instructions written after the branch instruction
### Overall sketch of the design 
![mips  3](https://github.com/mha66/MIPS-processor-pipelined/assets/123664862/82e85e6a-82a5-48a6-b66f-76feca8f5bbb)
