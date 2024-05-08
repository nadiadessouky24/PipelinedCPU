`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 06:16:21 PM
// Design Name: 
// Module Name: 4_1_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_4_1 #(parameter n=32)(
input  [n-1:0] a,
input  [n-1:0] b,
input  [n-1:0] c,
input  [n-1:0] d,
input  [1:0] sel,
output reg [n-1:0] out
);
    always@(*)
        begin
        case(sel)
            2'b00:
                out = a;
            2'b01:
                out = b;
            2'b10:
                out = c;
            2'b11:
                out = d;
            default:
                out = 1'b0;
        endcase
        end

endmodule
