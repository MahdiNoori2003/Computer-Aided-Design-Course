//defining controller datapath
`define Idle 0
`define Load 1
`define Init 2
`define Mul 3
`define Sum 4
`define Update 5

module Controller(input finish, start, clk, rst, 
				output reg ld_memory, ld_reg, sel,done);
	reg[2:0] ns, ps;
	
	//activing corresponding signals for each state
	always@(ps)begin
		ld_memory = 1'b0; ld_reg = 1'b0; sel = 1'b0;done = 1'b0;

		case(ps)
			`Idle: begin done=1'b1; end
			`Load: begin ld_memory=1'b1; end
		    `Init: begin ld_reg = 1'b1; sel = 1'b1;end
		    `Update: begin ld_reg = 1'b1; end
		endcase
	end

	//determining the next state
	always@(ps, finish, start, clk, rst)begin
	    case(ps)
		`Idle: ns = (start) ? `Load: `Idle;
		`Load: ns = (start) ? `Load: `Init;
		`Init: ns = `Mul;
		`Mul: ns = `Sum;
		`Sum: ns = (finish) ? `Idle: `Update;
		`Update: ns = `Mul;
	    endcase
	end

	//changing the current state
	always@(posedge clk)begin
		if (rst) ps = `Idle;
		else ps <= ns;
	end

endmodule