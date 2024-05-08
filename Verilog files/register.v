`timescale 1ns / 1ps


module register #(parameter n = 32)
(
input clk,
input rst,
input [4:0] read_1,
input [4:0] read_2,
input [4:0] write,
input [n-1:0] write_data,
input regWrite,
output [n-1:0] data_1,
output [n-1:0] data_2
 );
 
 
 reg [n-1:0] x[31:0];
 
 
initial begin 
    x[0] = 0; 
 end 
 
 assign data_1 = x[read_1];
 assign data_2 = x[read_2];
 
 integer i;
 
 always @ (posedge clk or posedge rst) begin
 
    if(rst == 1'b1) begin
//        x[0] = 0;
//        x[1] = 1;
//        x[2] = 2;
        for (i = 0;  i <32; i = i+1) begin
            x[i] = 0;
        end
        end
     else begin
        if(regWrite == 1'b1 && write != 0) begin
            x[write] = write_data;
        end
     end
    
        
 
 end
 
endmodule