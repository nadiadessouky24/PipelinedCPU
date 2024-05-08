module RCA  #(parameter N=32) (input wire [N-1:0] a, input wire [N-1:0] b, output [N-1:0] sum, output wire [N-1:0]  Cout);


full_adder1 fa(.A(a[0]),.B(b[0]),.cin(1'b0),.sum(sum[0]),.cout(Cout[0]));


genvar i;
generate
for (i=1; i<N; i = i+1 )  begin:f1

full_adder1 fa1(.A(a[i]),.B(b[i]),.cin(Cout[i-1]),.sum(sum[i]),.cout(Cout[i]));

end
endgenerate







endmodule
