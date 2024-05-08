


module full_adder1
(
    input A,
    input B,
    input cin,
    output wire sum,
    output wire cout
 );
 
 
  assign {cout,sum} = A + B + cin; 
 
endmodule