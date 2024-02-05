module Pu(
    input clk, rst,
    input [4:0] x1, x2, x3, x4, w1, w2, w3, w4, 
    output [11:0] out
);

    wire [9:0] mul_out1, mul_out2, mul_out3, mul_out4;
    wire [9:0] mul_reg_out1, mul_reg_out2, mul_reg_out3, mul_reg_out4;
    wire [10:0] add_out1, add_out2;
    wire [11:0] add_out;

    Mul #(5) Mult1(.a(x1), .b(w1), .out(mul_out1));
    Mul #(5) Mult2(.a(x2), .b(w2), .out(mul_out2));
    Mul #(5) Mult3(.a(x3), .b(w3), .out(mul_out3));
    Mul #(5) Mult4(.a(x4), .b(w4), .out(mul_out4));

    Register #(10) Rgstr1(.data_in(mul_out1), .clk(clk), .rst(rst), .en(1'b1), .out(mul_reg_out1));
    Register #(10) Rgstr2(.data_in(mul_out2), .clk(clk), .rst(rst), .en(1'b1), .out(mul_reg_out2));
    Register #(10) Rgstr3(.data_in(mul_out3), .clk(clk), .rst(rst), .en(1'b1), .out(mul_reg_out3));
    Register #(10) Rgstr4(.data_in(mul_out4), .clk(clk), .rst(rst), .en(1'b1), .out(mul_reg_out4));

    Adder #(11) Addr1(.a({mul_reg_out1[9], mul_reg_out1}), .b({mul_reg_out2[9],mul_reg_out2}),.cin(1'b0),.out(add_out1));
    Adder #(11) Addr2(.a({mul_reg_out3[9],mul_reg_out3}), .b({mul_reg_out4[9],mul_reg_out4}),.cin(1'b0),.out(add_out2));
    
    Adder #(12) Addr3(.a({add_out1[10],add_out1}), .b({add_out2[10],add_out2}),.cin(1'b0),.out(add_out));

    Register #(12) R5(.data_in(add_out), .clk(clk), .rst(rst), .en(1'b1), .out(out));
endmodule
