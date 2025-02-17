// file: controlUnit.v

`include "defines.v"

module ControlUnit(
input [6:0] IR,
output reg branch,
output reg MemRead,
output reg MemtoReg,
output reg [2:0] ALUOp,
output reg MemWrite,
output reg ALUSrc1,
output reg ALUSrc2,
output reg RegWrite,
output reg jump
);

  always @(*)
    begin
      case(`OPCODE)
        `OPCODE_Arith_R: 
                    begin
                      branch =   1'b0;
                      MemRead =  1'b0;
                      MemtoReg = 1'b0;
                      ALUOp =   `ALU_OP_Arith;
                      MemWrite = 1'b0;
                      ALUSrc1 =  1'b0; 
                      ALUSrc2 =   1'b0;
                      RegWrite = 1'b1;
                      jump = 1'b0;
                    end
        `OPCODE_Arith_I: 
                    begin
                      branch =   1'b0;
                      MemRead =  1'b0;
                      MemtoReg = 1'b0;
                      ALUOp =   `ALU_OP_Arith_I;
                      MemWrite = 1'b0;
                      ALUSrc1 =  1'b0; 
                      ALUSrc2 =   1'b1;
                      RegWrite = 1'b1;
                      jump = 1'b0;
                    end
        `OPCODE_LUI:
              begin
                          branch =   1'b0;
                          MemRead =  1'b0;
                          MemtoReg = 1'b0;
                          ALUOp =  `ALU_OP_PASS;
                          MemWrite = 1'b0;
                          ALUSrc1 =  1'b0;
                          ALUSrc2 =   1'b1;
                          RegWrite = 1'b1;
                          jump = 1'b0;
                        end
        `OPCODE_AUIPC:
                    begin
                          branch =   1'b0;
                          MemRead =  1'b0;
                          MemtoReg = 1'b0;
                          ALUOp =  `ALU_OP_Load;
                          MemWrite = 1'b0;
                          ALUSrc1 =  1'b1;
                          ALUSrc2 =   1'b1;
                          RegWrite = 1'b1;
                          jump = 1'b0;
                        end
            `OPCODE_Load:
                    begin
                      branch =   1'b0;
                      MemRead =  1'b1;
                      MemtoReg = 1'b1;
                      ALUOp =   `ALU_OP_Load;
                      MemWrite = 1'b0;
					  ALUSrc1 =  1'b0;
                      ALUSrc2 =   1'b1;
                      RegWrite = 1'b1;
                      jump = 1'b0;
                    end
        `OPCODE_Store: 
                    begin
                      branch =   1'b0;
                      MemRead =  1'b0;
                      ALUOp    = `ALU_OP_Load;
                      MemWrite = 1'b1;
                      ALUSrc1 =  1'b0;
                      ALUSrc2 =   1'b1;
                      RegWrite = 1'b0;
                      MemtoReg=  1'b0;
                      jump = 1'b0;
                    end
        `OPCODE_Branch: 
                    begin
                      branch =   1'b1;
                      MemRead =  1'b0;
                      ALUOp =   `ALU_OP_Branch;
                      MemWrite = 1'b0;
                      ALUSrc1 =  1'b0;
                      ALUSrc2 =   1'b0;
                      RegWrite = 1'b0;
                      MemtoReg=  1'b0;
                      jump = 1'b0;
                    end
		    `OPCODE_JAL: 
                    begin
                      branch =   1'b0;
                      MemRead =  1'b0;
                      ALUOp =   `ALU_OP_PASS;
                      MemWrite = 1'b0;
                      ALUSrc1 =  1'b0;
                      ALUSrc2 =   1'b1;
                      RegWrite = 1'b1;
                      MemtoReg=  1'b0;
                      jump = 1'b1;
                    end			
        `OPCODE_JALR: 
                    begin
                      branch =   1'b1;
                      MemRead =  1'b0;
                      ALUOp =   `ALU_OP_Load;
                      MemWrite = 1'b0;
                      ALUSrc1 =  1'b0;
                      ALUSrc2 =   1'b1;
                      RegWrite = 1'b1;
                      MemtoReg=  1'b0;
                      jump = 1'b1;
                    end			            
        default: 
                    begin 
                      branch =   1'b0;
                      MemRead =  1'b0;
                      ALUOp =   `ALU_OP_PASS;
                      MemWrite = 1'b0;
                      ALUSrc1 =  1'b0;
                      ALUSrc2 =   1'b0;
                      RegWrite = 1'b0;
                      MemtoReg=  1'b0;
                      jump =     1'b0;

                    end
      endcase
    end
endmodule