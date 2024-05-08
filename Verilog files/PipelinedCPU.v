`include "defines.v"

module PipelinedCPU(
        input clk,
        input rst,
        output [31:0] PCOut,
        output [31:0] BranchTargetAddr,
        output [31:0] PCIn,
        output [31:0] rs1,
        output [31:0] rs2,
        output [31:0] regFileIn,
        output [31:0] imm,
        output [31:0] shiftLeftOut,
		output [31:0] ALU1stSrc,
        output [31:0] ALU2ndSrc,
        output [31:0] ALUOut,
        output  [31:0] memoryOut,
        output  [31:0] IR,
        output branch,
        output MemRead,
        output MemtoReg,
        output MemWrite,
		output ALUSrc1, 
        output ALUSrc2,
        output RegWrite
    );
    
    wire [2:0] ALUOp;
    wire [4:0]ALUSelection;
    wire zf,cf,sf,vf;
    wire [31:0] PCPlus4;
	wire jump;
    wire [31:0] rdSrc;
    wire BCUOut;
    wire pcLoad;
    reg sclk;

    always @(posedge clk or posedge rst) 
    begin
    if (rst)
    sclk=1'b0;
    else
    sclk = ~sclk;
    end
//all wire initializations 
    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_PC_PLUS4;
    wire [31:0] IF_ID_INST;
    wire [31:0] ID_EX_PC;
    wire [31:0] ID_EX_PC_PLUS4;
    wire [31:0] ID_EX_READ_DATA1;
    wire [31:0] ID_EX_READ_DATA2;
    wire [31:0] ID_EX_IMM;
    wire [2:0] ID_EX_F3;
    wire  [6:0] ID_EX_F7;
    wire [4:0] ID_EX_RD;
    wire[4:0] ID_EX_RS1;
    wire[4:0]ID_EX_RS2;
     wire [6:0] ID_EX_INST;
    wire ID_EX_BRANCH,ID_EX_MEM_READ, ID_EX_MEM_TO_REG,
         ID_EX_MEM_WRITE,ID_EX_ALU_SRC1, ID_EX_ALU_SRC2,
         ID_EX_REG_WRITE,ID_EX_JUMP;
    wire [2:0] ID_EX_ALU_OP;
    wire [31:0] EX_MEM_PC ;                                  
    wire [31:0] EX_MEM_PC_PLUS4;                             
    wire  [31:0] EX_MEM_BRANCH_TARGET_ADDRESS;               
    wire [2:0]  EX_MEM_F3;                                   
    wire [31:0]EX_MEM_READ_DATA2;                            
    wire  EX_MEM_BRANCH,   EX_MEM_MEM_READ,EX_MEM_MEM_TO_REG,
          EX_MEM_MEM_WRITE, EX_MEM_REG_WRITE,EX_MEM_JUMP;    
    wire EX_MEM_CF,EX_MEM_ZF,EX_MEM_VF,EX_MEM_SF;            
    wire[31:0] EX_MEM_ALU_OUT;                               
    wire [31:0] MEM_WB_PC_PLUS4;                             
       wire [31:0] MEM_WB_ALU_OUT;                           
       wire [31:0] MEM_WB_MEMORY_OUT;                        
       wire MEM_WB_MEM_TO_REG, MEM_WB_REG_WRITE, MEM_WB_JUMP;
	  wire [4:0] EX_MEM_RD;
	  wire [4:0]MEM_WB_RD ;
	  wire [1:0] forwardA;
	  wire [1:0] forwardB;
	  wire [31:0] RS1_forwarded;
      wire [31:0] RS2_forwarded;
	  wire flush = (BCUOut | EX_MEM_JUMP);


// all moddules 
	 RCA PCAdder(.a(PCOut), .b(32'd4),.sum(PCPlus4),.Cout());
	 
	 
    Nbit_reg #(32) PC (.clk(sclk),.rst(rst),.D(PCIn),.load(pcLoad), .Q(PCOut));

  wire [11:0] memAddr=(~ sclk)? EX_MEM_ALU_OUT[11:0]:PCOut[11:0];

   singlePortedMemory Mem( .sclk(sclk), .clk(clk),.rst(rst),
             .addr(memAddr),.data_in(EX_MEM_READ_DATA2),  
        .mem_read(EX_MEM_MEM_READ), .mem_write(EX_MEM_MEM_WRITE),
         .F3(EX_MEM_F3),
         .data_out(IR)
   );

     assign pcLoad = ((~(IF_ID_INST[6:2]==`OPCODE_FENCE)&&~(IF_ID_INST[6:2]==`OPCODE_SYSTEM))); 
     wire [31:0] NO_OP= 32'h13;
     wire [31:0] NOP_OR_INST= (sclk)? IR:NO_OP;
        Nbit_reg #(.n(96)) IF_ID( .clk(clk),.rst(rst),
                              .D({PCOut,PCPlus4,NOP_OR_INST}), .load(1'b1), 
                               .Q({IF_ID_PC,IF_ID_PC_PLUS4,IF_ID_INST})); 
                               
    ControlUnit CU(IF_ID_INST[6:0], branch, MemRead,MemtoReg, ALUOp,MemWrite,  ALUSrc1, ALUSrc2, RegWrite, jump);

    ImmGen immgen(IF_ID_INST,imm); 
     register regFile(~clk, rst, IF_ID_INST[`IR_rs1], IF_ID_INST[`IR_rs2], MEM_WB_RD, 
                                regFileIn,  MEM_WB_REG_WRITE, rs1, rs2 ); 
      
                
              Nbit_reg #(.n(300)) ID_EX( .clk(clk),.rst(rst),.load(~flush), .D({IF_ID_PC,IF_ID_PC_PLUS4,IF_ID_INST[6:0],IF_ID_INST[`IR_rs1], IF_ID_INST[`IR_rs2],rs1, rs2,IF_ID_INST[`IR_funct3],IF_ID_INST[`IR_funct7],
                                       imm, IF_ID_INST[`IR_rd],branch, MemRead,MemtoReg,MemWrite,ALUSrc1, ALUSrc2,RegWrite, jump,ALUOp}),                              
                                    .Q({
                                       ID_EX_PC, ID_EX_PC_PLUS4,ID_EX_INST[6:0],
                                        ID_EX_RS1,ID_EX_RS2,
                                      ID_EX_READ_DATA1,  ID_EX_READ_DATA2,
                                      ID_EX_F3,ID_EX_F7,
                                       ID_EX_IMM,ID_EX_RD, 
                                       ID_EX_BRANCH,ID_EX_MEM_READ, ID_EX_MEM_TO_REG,
                                       ID_EX_MEM_WRITE,ID_EX_ALU_SRC1, ID_EX_ALU_SRC2,
                                       ID_EX_REG_WRITE,ID_EX_JUMP,
                                        ID_EX_ALU_OP
                                       }) 
                                     );   

  forwarding ForwardingUnit(ID_EX_RS1,ID_EX_RS2,
                    EX_MEM_RD,MEM_WB_RD,
                    EX_MEM_REG_WRITE,MEM_WB_REG_WRITE
                     ,forwardA, forwardB);

     n_bit_Mux Rs1ForwardMux(.A(ID_EX_READ_DATA1),.B(regFileIn),
                          .S(forwardA[0]), .C(RS1_forwarded));
                          
     n_bit_Mux Rs2ForwardMux(.A(ID_EX_READ_DATA2),.B(regFileIn), 
                             .S(forwardB[0]),.C(RS2_forwarded));

   n_bit_Mux  ALUSrc1Mux(.A(RS1_forwarded),.B(ID_EX_PC),.S(ID_EX_ALU_SRC1),.C(ALU1stSrc));
   n_bit_Mux  ALUSrc2Mux(.A(RS2_forwarded),.B(ID_EX_IMM),.S(ID_EX_ALU_SRC2),.C(ALU2ndSrc));

    ALU_CU ALUControl(ID_EX_ALU_OP,  ID_EX_F3, ID_EX_F7 ,ALUSelection);
    
    n_bit_ALU ALU(.a(ALU1stSrc), .b(ALU2ndSrc), .shamt(ALU2ndSrc[4:0]),
                  .cf(cf), .zf(zf), .vf(vf), .sf(sf)
                 , .alufn(ALUSelection), .r(ALUOut));
  RCA BranchTargetAdder( .a(ID_EX_PC),  .b(ID_EX_IMM),  .sum(BranchTargetAddr), .Cout()); 
  
    
   Nbit_reg #(.n(178)) EX_MEM( .clk(clk),.rst(rst), .load(1'b1),
                          .D({
                          ID_EX_RD,
                           ID_EX_PC, IF_ID_PC_PLUS4,
                           BranchTargetAddr,
                            ID_EX_BRANCH,    ID_EX_MEM_READ,   ID_EX_MEM_TO_REG,
                            ID_EX_MEM_WRITE, ID_EX_REG_WRITE,  ID_EX_JUMP,
                            ID_EX_F3,
                            RS2_forwarded,
                             cf, zf, vf, sf,
                              ALUOut
                           }),    
                          .Q({EX_MEM_RD,
                          EX_MEM_PC,EX_MEM_PC_PLUS4,
                            EX_MEM_BRANCH_TARGET_ADDRESS,
                             EX_MEM_BRANCH,    EX_MEM_MEM_READ,   EX_MEM_MEM_TO_REG, 
                             EX_MEM_MEM_WRITE, EX_MEM_REG_WRITE,  EX_MEM_JUMP,
                             EX_MEM_F3,
                             EX_MEM_READ_DATA2,
                             EX_MEM_CF, EX_MEM_ZF, EX_MEM_VF, EX_MEM_SF,
                             EX_MEM_ALU_OUT }) ); 

   	mux_4_1 PCInMux (PCPlus4,EX_MEM_BRANCH_TARGET_ADDRESS,
   	                EX_MEM_BRANCH_TARGET_ADDRESS,EX_MEM_ALU_OUT, 
   	                {EX_MEM_JUMP,BCUOut}, PCIn); 

	Branch_CU bcu(.zf(EX_MEM_ZF), .cf(EX_MEM_CF),.sf(EX_MEM_SF), .vf(EX_MEM_VF),
	       .funct3(EX_MEM_F3) ,.branchSignal(EX_MEM_BRANCH) , .PCSrc(BCUOut));

 Nbit_reg #(.n(300)) MEM_WB(.clk(clk),.rst(rst), .load(1'b1),
                                 .D({EX_MEM_RD,
                                 EX_MEM_PC_PLUS4,
                                 EX_MEM_MEM_TO_REG,EX_MEM_REG_WRITE,  EX_MEM_JUMP,     
                                 EX_MEM_ALU_OUT,
                                 IR
                                  }),    
                                  .Q({MEM_WB_RD,
                                    MEM_WB_PC_PLUS4,
                                   MEM_WB_MEM_TO_REG, MEM_WB_REG_WRITE,MEM_WB_JUMP,
                                   MEM_WB_ALU_OUT,
                                   MEM_WB_MEMORY_OUT
                                  }) );  
  	
  	mux_4_1 RegFileInMux (MEM_WB_ALU_OUT,MEM_WB_MEMORY_OUT,
                         MEM_WB_PC_PLUS4,MEM_WB_PC_PLUS4,
                        {MEM_WB_JUMP,MEM_WB_MEM_TO_REG}, regFileIn);

    
endmodule