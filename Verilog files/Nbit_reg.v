`timescale 1ns / 1ps


module Nbit_reg #(parameter n = 8)
(
    input clk,
    input load,
    input rst,
    input [n-1:0] D,
    output reg [n-1:0] Q
 );

always @ (posedge clk or posedge rst) begin
    if (rst == 1) begin
        Q <= 0;
    end 
    else if (load == 1) begin 
        Q <= D;
    end
    else begin 
        Q <= Q;
    end
end
// wire [n-1:0] y; 
// genvar i; 
 
// generate
//    for (i = 0;i<n; i=i+1) begin
//        mux m (Q[i], D[i], load, y[i]);
//        DFlipFlop ff (clk, rst, y[i], Q[i]);
//    end 
//endgenerate
endmodule