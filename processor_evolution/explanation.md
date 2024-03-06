# Explanation of steps

This directory holds a track of all modified files for each session.

The organization of this directory should be as follows:
s[lab session number]__obj[objective number]_[file name].v

## Session 1

- Obj-1 and 2:
  - Modified: **control_unit.v**
    Added all control signals for all 5 instruction types that were missing (ALU_I, BRANCH_EQ, JUMP, LOAD, STORE).
- Obj-3:
  - Modified: **alu_control.v**
    func7_5 was 1 bit, then changed to 7 bit width because we want to identify the MUL instruction.
    Defined a new ALU control code MUL_OP = 4'd8, where 8 is a random number but different from others.
    Modified all function fields to 10 bits.
    Defined a new function field FUNC_MUL = 10'b0000001000; // func7_5 = 0000001 and func3 = 000.
  - Modified: **alu.v**
    Defined a new arithmetic operation: mul_out  =   alu_in_0 * alu_in_1
  - Modified: **cpu.v**
    Defined the part of the instruction that reads the funct7 field in the instanciation of alu_control.v: .func7_5 (instruction[31:25])
