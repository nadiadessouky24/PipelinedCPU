
`include "defines.v"


module ALU_CU(input [2:0] ALUOp, input [`IR_funct3] F3, input [`IR_funct7] F7, output reg [4:0] ALUSelection );


  always@(*)
    case(ALUOp)
      `ALU_OP_Load:  ALUSelection = `ALU_ADD ;
	  `ALU_OP_PASS:  ALUSelection = `ALU_PASS;
      `ALU_OP_Arith_I:  
        case(F3)
                `F3_ADD: ALUSelection= `ALU_ADD;
                `F3_OR: ALUSelection =`ALU_OR ;
                `F3_XOR: ALUSelection =`ALU_XOR;
                `F3_AND: ALUSelection = `ALU_AND ;
              
                `F3_SLL: ALUSelection =`ALU_SLL;
                `F3_SRL: ALUSelection =(F7[30]==1'b1)?`ALU_SRA:`ALU_SRL;

                `F3_SLT: ALUSelection =`ALU_SLT;
                `F3_SLTU: ALUSelection =`ALU_SLTU;
              endcase
      `ALU_OP_Arith: 
        if(F7[25]==1'b1)//MUL/DIV
          case(F3)
          `F3_MUL   : ALUSelection=`ALU_MUL;           
          `F3_MULH  : ALUSelection=`ALU_MULH;            
          `F3_MULHSU: ALUSelection=`ALU_MULHSU;            
          `F3_MULHU : ALUSelection=`ALU_MULHU;            
          `F3_DIV   : ALUSelection=`ALU_DIV ;            
          `F3_DIVU  : ALUSelection=`ALU_DIVU;            
          `F3_REM   : ALUSelection=`ALU_REM ;            
          `F3_REMU  : ALUSelection=`ALU_REMU;            
                
           endcase
         else
           case(F3)
          
          `F3_ADD: ALUSelection= (F7[30]==1'b0)?`ALU_ADD:`ALU_SUB;
          `F3_OR: ALUSelection =`ALU_OR ;
          `F3_XOR: ALUSelection =`ALU_XOR;
          `F3_AND: ALUSelection = `ALU_AND ;
        
          `F3_SLL: ALUSelection =`ALU_SLL;
          `F3_SRL: ALUSelection =(F7[30]==1'b1)?`ALU_SRA:`ALU_SRL;

          `F3_SLT: ALUSelection =`ALU_SLT;
          `F3_SLTU: ALUSelection =`ALU_SLTU;
                
        endcase
      
      default: ALUSelection =`ALU_PASS; 

    endcase


endmodule