module Encoder(input Z_0, Z_1, Z_2, Z_3, 
                output [1:0] Out);
	
	//defining the encoded output
	assign Out = (~Z_0 & Z_1 & Z_2 & Z_3) ? 2'b00:
			     (Z_0 & ~Z_1 & Z_2 & Z_3) ? 2'b01:
			     (Z_0 & Z_1 & ~Z_2 & Z_3) ? 2'b10:
			     (Z_0 & Z_1 & Z_2 & ~Z_3) ? 2'b11:
			     (Z_0 & Z_1 & Z_2 & Z_3) ? 2'b00: 2'bxx; 
endmodule