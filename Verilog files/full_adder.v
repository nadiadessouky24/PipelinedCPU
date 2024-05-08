


module full_adder
(
    input A,
    input B,
    input cin,
    output wire sum,
    output wire cout
 );
 
 
  assign {cout,sum} = A + B + cin; 
 
endmodule