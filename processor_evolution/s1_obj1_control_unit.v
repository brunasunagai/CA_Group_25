// module: Control
// Function: Generates the control signals for each one of the datapath resources

module control_unit(
      input  wire [6:0] opcode,
      output reg  [1:0] alu_op,
      output reg        reg_dst,
      output reg        branch,
      output reg        mem_read,
      output reg        mem_2_reg,
      output reg        mem_write,
      output reg        alu_src,
      output reg        reg_write,
      output reg        jump
   );

   // RISC-V opcode[6:0] (see RISC-V greensheet)
   parameter integer ALU_R      = 7'b0110011;
   parameter integer ALU_I      = 7'b0010011;
   parameter integer BRANCH_EQ  = 7'b1100011;
   parameter integer JUMP       = 7'b1101111;
   parameter integer LOAD       = 7'b0000011;
   parameter integer STORE      = 7'b0100011;

   // RISC-V ALUOp[1:0] (see book Figure 4.12)
   parameter [1:0] ADD_OPCODE     = 2'b00;
   parameter [1:0] SUB_OPCODE     = 2'b01;
   parameter [1:0] R_TYPE_OPCODE  = 2'b10;

   //The behavior of the control unit can be found in Chapter 4, Figure 4.18

   always@(*)begin

      case(opcode)
         ALU_R:begin
            alu_src   = 1'b0;
            mem_2_reg = 1'b0;
            reg_write = 1'b1;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            branch    = 1'b0;
            alu_op    = R_TYPE_OPCODE;
            jump      = 1'b0;
         end
         
         ////////////////////////////////////////////////////////////////////
         // Begin of modified part:
         ////////////////////////////////////////////////////////////////////

         ALU_I:begin // addi
            alu_src   = 1'b1; // ALU's 2nd operand from immediate
            mem_2_reg = 1'b0; // result from ALU
            reg_write = 1'b1; // write in rd
            mem_read  = 1'b0; // don't read from data mem
            mem_write = 1'b0; // don't write in data mem
            branch    = 1'b0; // don't branch
            alu_op    = ADD_OPCODE;
            jump      = 1'b0; // don't unconditional jump
         end

         BRANCH_EQ:begin
            alu_src   = 1'b0; // ALU's 2nd operand from rs2
            mem_2_reg = 1'b0; // resul from ALU
            reg_write = 1'b0; // don't write in rd
            mem_read  = 1'b0; // don't read from data mem
            mem_write = 1'b0; // don't write in data mem
            branch    = 1'b1; // branch
            alu_op    = SUB_OPCODE;
            jump      = 1'b0; // don't unconditional jump
         end

         JUMP:begin // immediate value = jump target; destionation register = return address
            alu_src   = 1'b0; // dont care
            mem_2_reg = 1'b0; // dont care but not sure
            reg_write = 1'b1; // write RA in rd
            mem_read  = 1'b0; // don't read from data mem
            mem_write = 1'b0; // don't write in data mem
            branch    = 1'b0; // don't branch
            alu_op    = R_TYPE_OPCODE; // dont care but not sure
            jump      = 1'b1; // UNCONDITIONAL JUMP
         end

         LOAD:begin
            alu_src   = 1'b1; // ALU's 2nd operand from immediate
            mem_2_reg = 1'b1; // read data from data mem
            reg_write = 1'b1; // write in rd
            mem_read  = 1'b1; // read from data mem
            mem_write = 1'b0; // don't write in data mem
            branch    = 1'b0; // don't branch
            alu_op    = ADD_OPCODE;
            jump      = 1'b0; // don't unconditional jump
         end

         STORE:begin
            alu_src   = 1'b1; // 2nd operand is immediate to calculate the address where data will be written in data mem
            mem_2_reg = 1'b0; // dont care but not sure
            reg_write = 1'b0; // don't write in register file
            mem_read  = 1'b0; // don't read from data mem
            mem_write = 1'b1; // write in data mem
            branch    = 1'b0; // don't branch
            alu_op    = ADD_OPCODE;
            jump      = 1'b0; // don't unconditional jump
         end

         ////////////////////////////////////////////////////////////////////
         // End of modified part
         ////////////////////////////////////////////////////////////////////

         default:begin
            alu_src   = 1'b0;
            mem_2_reg = 1'b0;
            reg_write = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            branch    = 1'b0;
            alu_op    = R_TYPE_OPCODE;
            jump      = 1'b0;
         end
      endcase
   end

endmodule



