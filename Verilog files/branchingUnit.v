module branchingUnit(
  input B,            // Branching signal from Control Unit
  input jump,
  input [2:0] funct3,  // Instruction[12:14]
  input [31:0] data1,
  input [31:0] data2,
  output reg [1:0] decision       // Final branching decision
);

  always @* begin
    if (B == 1'b1) begin
      if (jump)
        decision = 2'b01;
      else begin
        case (funct3)
          3'b000: decision = {1'b0, (data1 == data2)};    // BEQ
          3'b001: decision = {1'b0, ~(data1 == data2)};   // BNE
          3'b100: decision = {1'b0, $signed(data1) < $signed(data2)};    // BLT
          3'b101: decision = {1'b0, $signed(data1) >= $signed(data2)};   // BGE
          3'b110: decision = {1'b0, data1 < data2};        // BLTU
          3'b111: decision = {1'b0, data1 >= data2};       // BGEU
          default: decision = 2'b00;                       // Default case: does not branch
        endcase
      end
    end else
      decision = (jump) ? 2'b10 : 2'b00;
  end

endmodule
