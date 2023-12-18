module Register(input[31:0] a,
				output reg [31:0] b,
				input clk,rst,ld);


	always@(posedge clk) begin
		if (rst == 1)
			b <= 0;
		else if (ld == 1)
			b <= a;
	
end
endmodule
