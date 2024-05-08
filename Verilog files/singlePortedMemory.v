`include "defines.v"

module singlePortedMemory(
        input sclk,
        input clk,
        input rst,
        input [11:0] addr,
        input [31:0] data_in,  
        input mem_read,
        input mem_write,
        input [2:0] F3,
       output reg [31:0] data_out
    );
    
    
    parameter  mem_size=2048;   
    parameter  offset=mem_size/2;
    reg [7:0] mem [0:(mem_size-1)];

    
    initial begin
                 {mem[3],mem[2],mem[1],mem[0]}=        32'h00000033; //add x0, x0, x0
                 {mem[7],mem[6],mem[5],mem[4]}=        32'h00002083; //lw x1, 0(x0)
                 {mem[11],mem[10],mem[9],mem[8]}=      32'h00402103; //lw x2, 4(x0)
                 {mem[15],mem[14],mem[13],mem[12]}=    32'h00802183; //lw x3, 8(x0)
                 {mem[19],mem[18],mem[17],mem[16]}=    32'h0020e233; //or x4, x1, x2
                 {mem[23],mem[22],mem[21],mem[20]}=    32'h00000033; //beq x4, x3, 16
                 {mem[27],mem[26],mem[25],mem[24]}=    32'h002081b3; //add x3, x1, x2
                 {mem[31],mem[30],mem[29],mem[28]}=    32'h002182b3; //add x5, x3, x2
                 {mem[35],mem[34],mem[33],mem[32]}=    32'h00502623; //sw x5, 12(x0)
                 {mem[39],mem[38],mem[37],mem[36]}=    32'h00c02303; //lw x6, 12(x0)
                 {mem[43],mem[42],mem[41],mem[40]}=    32'h001373b3; //and x7, x6, x1
                 {mem[47],mem[46],mem[45],mem[44]}=    32'h40208433; //sub x8, x1, x2
                 {mem[51],mem[50],mem[49],mem[48]}=    32'h00208033; //add x0, x1, x2
                 {mem[55],mem[54],mem[53],mem[52]}=    32'h001004b3; //add x9, x0, x1
                 {mem[59],mem[58],mem[57],mem[56]}=    32'h001004b3; //add x9, x0, x1

                   {mem[3 +offset ],mem[2+offset],mem[1+offset],mem[0+offset]}=32'd17;
                   {mem[7 +offset ],mem[6+offset],mem[5+offset],mem[4+offset]}=32'd9;
                   {mem[11 +offset],mem[10+offset],mem[9+offset],mem[8+offset]}=32'd25;
       end 
    
     
      
      integer i;
      always@(posedge clk) // for writing 
        begin 
          if (rst==1'b1)
            begin
            for (i=12+offset;i<mem_size;i=i+1)
              mem[i] = 8'd0;
            end      
          else if (mem_write)
              case (F3)
                `F3_LB: mem[addr+offset] =  data_in[7:0]; //SB
                `F3_LH: {mem[addr+offset+1], mem[addr+offset]} =  data_in[15:0];
                `F3_LW: {mem[addr+offset+3], mem[addr+offset+2],mem[addr+offset+1], mem[addr+offset]} = data_in; //SW
              endcase
        end
        
   
     always@(*) // for reading
             begin
                if(rst)data_out=32'd0;
                else if(sclk) //data memory
                    begin
                        data_out ={mem[addr+3],mem[addr+2],mem[addr+1] ,mem[addr]};
                    end  
               else   
                      begin 
                        if (mem_read == 1'b1)
                           case (F3)
                             `F3_LW: data_out =  { mem[addr+offset+3],mem[addr+offset+2],mem[addr+offset+1],  mem[addr+offset]}; 
                             `F3_LH: data_out =  {{16{mem[addr+offset+1][7]}},mem[addr+offset+1],  mem[addr+offset]}; 
                             `F3_LB: data_out =  {{24{mem[addr+offset][7]}},  mem[addr+offset]}; 
                             `F3_LHU: data_out =  {{16{1'b0}},mem[addr+offset+1],  mem[addr+offset]}; 
                             `F3_LBU: data_out =  {{24{1'b0}},  mem[addr+offset]}; 
                              default: data_out = 32'd0;
                           endcase
                        else if (mem_read ==1'b0)
                             data_out = 32'd0; 
                    end      
           end
endmodule