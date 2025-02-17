module shifter (input [31:0] a, input [4:0] shamt, input [1:0] type, output reg [31:0] r);

wire signed [31:0] w=$signed(a);
always @ (*) begin
	case(type)
		2'b00: r = a >> shamt; // SRL - (shift right logical)
		2'b01: r = a << shamt; // SLL - (shift left logical)
		2'b10: r = $signed(w)>>>shamt; // SRA - (shift right arithmetic)
		default: r = a << 0;
	endcase
end

endmodule 