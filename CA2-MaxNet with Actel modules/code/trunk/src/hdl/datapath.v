module datapath (
    input [4:0] X1, X2, X3, X4,
    input clk, rst, ld_t, sel, 
    output [4:0] max, 
    output finish
);

    wire [4:0] w1, w2, w3, w4;
    wire [11:0] PU_out1, PU_out2, PU_out3, PU_out4;
    wire [4:0] relu_out1, relu_out2, relu_out3, relu_out4;
    wire [4:0] x1, x2, x3, x4;
    wire [1:0] res_sel;
    wire z1, z2, z3, z4;

    four_to_one_mux_parametrized #(5) M1(.a(X1), .b(X2), .c(X3), .d(X4), .sel(res_sel), .out(max));

    two_to_one_mux_parametrized #(5) M2(.a(X1), .b(relu_out1), .sel(sel), .out(w1));
    two_to_one_mux_parametrized #(5) M3(.a(X2), .b(relu_out2), .sel(sel), .out(w2));
    two_to_one_mux_parametrized #(5) M4(.a(X3), .b(relu_out3), .sel(sel), .out(w3));
    two_to_one_mux_parametrized #(5) M5(.a(X4), .b(relu_out4), .sel(sel), .out(w4));

    Register #(5) temp1(.data_in(w1), .en(ld_t), .clk(clk), .rst(rst), .out(x1));
    Register #(5) temp2(.data_in(w2), .en(ld_t), .clk(clk), .rst(rst), .out(x2));
    Register #(5) temp3(.data_in(w3), .en(ld_t), .clk(clk), .rst(rst), .out(x3));
    Register #(5) temp4(.data_in(w4), .en(ld_t), .clk(clk), .rst(rst), .out(x4));

    Or_bitwise or1(.a(relu_out1), .out(z1));
    Or_bitwise or2(.a(relu_out2), .out(z2));
    Or_bitwise or3(.a(relu_out3), .out(z3));
    Or_bitwise or4(.a(relu_out4), .out(z4));

    Encoder encode(.z1(z1), .z2(z2), .z3(z3), .z4(z4), .out(res_sel));

    Done_checker checker(.z1(z1), .z2(z2), .z3(z3), .z4(z4), .finish(finish));

    wire [4:0] w1_P1, w2_P1, w3_P1, w4_P1;
    wire [4:0] w1_P2, w2_P2, w3_P2, w4_P2;
    wire [4:0] w1_P3, w2_P3, w3_P3, w4_P3;
    wire [4:0] w1_P4, w2_P4, w3_P4, w4_P4;
    Buffer buff(.clk(clk),.rst(rst),.W0(w1_P1),.W1(w2_P1),.W2(w3_P1),.W3(w4_P1),.W4(w1_P2),.W5(w2_P2),  .W6(w3_P2),  .W7(w4_P2), .W8(w1_P3),  .W9(w2_P3),  .W10(w3_P3), .W11(w4_P3), .W12(w1_P4), .W13(w2_P4), .W14(w3_P4), .W15(w4_P4));

    Pu Pu_1(.x1(x1), .x2(x2), .x3(x3), .x4(x4), .w1(w1_P1), .w2(w2_P1), .w3(w3_P1), .w4(w4_P1), .clk(clk), .rst(rst), .out(PU_out1));
    
    Pu Pu_2(.x1(x1), .x2(x2), .x3(x3), .x4(x4), .w1(w1_P2), .w2(w2_P2), .w3(w3_P2), .w4(w4_P2), .clk(clk), .rst(rst), .out(PU_out2));
    
    Pu Pu_3(.x1(x1), .x2(x2), .x3(x3), .x4(x4), .w1(w1_P3), .w2(w2_P3), .w3(w3_P3), .w4(w4_P3), .clk(clk), .rst(rst), .out(PU_out3));
    
    Pu Pu_4(.x1(x1), .x2(x2), .x3(x3), .x4(x4), .w1(w1_P4), .w2(w2_P4), .w3(w3_P4), .w4(w4_P4), .clk(clk), .rst(rst), .out(PU_out4));
  

    Relu r1(.in(PU_out1), .out(relu_out1));
    Relu r2(.in(PU_out2), .out(relu_out2));
    Relu r3(.in(PU_out3), .out(relu_out3));
    Relu r4(.in(PU_out4), .out(relu_out4));

endmodule
