
`timescale 1ns / 1ps

module tb;
    reg clk;
    reg rst;

    

  localparam period = 10;
 
     initial begin
        clk = 1'b0;
       end
       
       initial begin
        forever  #(period/2) clk = ~clk;
        end
       
       initial begin
        rst = 1; 
        #(period)
        rst = 0; 
      end
     
     PipelinedCPU cpu (clk, rst);
     
endmodule