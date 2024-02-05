module pc #(parameter WIDTH) (input clk,rst,sel,en,
    input[WIDTH-1:0] init_pc,
    output [WIDTH-1:0] pc_out
);
    wire [WIDTH-1:0]mux_out,reg_out,sum;

    // stores the desired memory address 

    adder #(WIDTH)Adder(.a({{(WIDTH-3){1'b0}},3'b100}),.b(reg_out),.sum(sum));
    register #(WIDTH) Reg(.data_in(mux_out),.ld(en),.clk(clk),.rst(rst),.data_out(reg_out));
    two_to_one_mux #(WIDTH) Mux(.sel(sel),.data_0(sum),.data_1(init_pc),.data_out(mux_out));
    
    assign pc_out = reg_out;
endmodule