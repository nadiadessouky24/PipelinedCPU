`timescale 1ns / 1ps


module forwarding(
input [4:0]ID_EX_Rs1,
input [4:0] ID_EX_Rs2,

input EX_MEM_RegWrite,
input [4:0] EX_MEM_RD,

input MEM_WB_RegWrite,
input [4:0] MEM_WB_RD,

output reg [1:0]forwardA,
output reg [1:0] forwardB
    );
    
    always @(*) begin
    
    //Forward A detection
        if ( EX_MEM_RegWrite & (EX_MEM_RD != 0)  & (EX_MEM_RD == ID_EX_Rs1) ) begin //EX mem detection
            forwardA = 2'b10; 
        end else 
        
         if ( MEM_WB_RegWrite & (MEM_WB_RD != 0) & (MEM_WB_RD == ID_EX_Rs1)) //Mem hazard Detection
//            &&  ~( EX_MEM_RegWrite && (EX_MEM_RD != 0))
//            && (EX_MEM_RD == ID_EX_Rs1) ) 
            
                forwardA = 2'b01;
                
            else forwardA =2'b00;
        
       //Forward B detection   
        if ( EX_MEM_RegWrite & (EX_MEM_RD != 0)  & (EX_MEM_RD == ID_EX_Rs2) ) begin // EX mem detection
            forwardB = 2'b10;
            end
       else if ( MEM_WB_RegWrite& (MEM_WB_RD != 0) & (MEM_WB_RD == ID_EX_Rs2)) //Mem Hazard detection
//            &  ~( EX_MEM_RegWrite & (EX_MEM_RD != 0))
//            &(EX_MEM_RD == ID_EX_Rs2) ) 
            
            forwardB = 2'b01;
                
         else forwardB =2'b00;
                
                
    end
    



endmodule
