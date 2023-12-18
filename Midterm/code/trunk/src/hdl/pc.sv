module pc(input clk,rst,sel,en,
    input[8:0] init_pc,
    output [8:0] pc_out
);
    wire [8:0]mux_out,reg_out,sum;

    // stores the desired memory address 

    adder #(9)Adder(.a(9'd4),.b(reg_out),.sum(sum));
    register #(9) Reg(.data_in(mux_out),.ld(en),.clk(clk),.rst(rst),.data_out(reg_out));
    two_to_one_mux Mux(.sel(sel),.data_0(sum),.data_1(init_pc),.data_out(mux_out));
    
    assign pc_out = reg_out;
endmodule