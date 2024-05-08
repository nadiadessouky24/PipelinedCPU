`timescale 1ns / 1ps

module Hazard(
input [4:0] IF_ID_RS1,
input [4:0] IF_ID_RS2,
input [4:0]ID_EX_RD,
input ID_EX_MemRead,

output reg stall
    );
    
    always @ (*) begin
    
     if (( (IF_ID_RS1==ID_EX_RD) || (IF_ID_RS2==ID_EX_RD) ) 
	           && ID_EX_MemRead 
	           && ID_EX_RD != 0 ) begin
	
        stall = 1;
        end 
        else begin
            stall = 0; 
        end 
    end
     
   
     
endmodule
