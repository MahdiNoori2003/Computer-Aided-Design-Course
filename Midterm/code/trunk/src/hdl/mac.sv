module mac(input clk,rst,reg_en,clr,
    input [7:0] pixel,weight,
    output [7:0] result
);

    wire [11:0] sum, reg_out;
    wire [7:0] mul_res;

    // finds the value of one bytes numbers and stores it in its register 
    register #(12) Reg(.clk(clk),.rst(rst|clr),.data_in(sum),.ld(reg_en),.data_out(reg_out));
    mul Mul(.a(pixel),.b(weight),.result(mul_res));
    adder #(12) Adder(.a({{4'd0},mul_res}),.b(reg_out),.sum(sum));

    assign result = reg_out[11:4];

endmodule