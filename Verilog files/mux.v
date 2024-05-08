`timescale 1ns / 1ps

module mux
(
    input A,
    input B,
    input S,
    output M
);

    wire a_0;
    wire a_1;
    
    assign M = (S==0)? A :B;

endmodule
