`timescale 1ns / 1ps



module n_bit_Mux #(parameter n = 32)
(
    input [n-1:0] A,
    input [n-1:0] B,
    input S,
    output [n-1:0] C
    
);


genvar i;

generate
    for (i = 0; i<n; i = i+1) begin
        mux  m (A[i], B[i], S, C[i]);
     end 
endgenerate


endmodule