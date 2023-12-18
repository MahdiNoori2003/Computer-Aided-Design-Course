module Pu(input [31:0] X_0, X_1, X_2, X_3, W_0, W_1, W_2, W_3, 
            input clk, rst, 
            output reg [31:0] PU_out , 
            output Zero_sign);

    wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11 , w12;
    wire [31:0] PUout;

    //set of floating point multipliers for W * X operation
    F_Mul M1(X_0, W_0, w1);
    F_Mul M2(X_1, W_1, w2);
    F_Mul M3(X_2, W_2, w3);
    F_Mul M4(X_3, W_3, w4);

    //storing multiplication results
    Register R1(w1,w5,clk,rst,1'b1);
    Register R2(w2,w6,clk,rst,1'b1);
    Register R3(w3,w7,clk,rst,1'b1);
    Register R4(w4,w8,clk,rst,1'b1);

    //summing the result in a tree manner
    F_Adder A1(w5, w6, w9);
    F_Adder A2(w7, w8, w10);
    F_Adder A3(w9, w10, w11);

    Register R5(w11,w12,clk,rst,1'b1);

    //applying RELU to the output
    Relu relu(w12,Zero_sign,PUout);

    assign PU_out = PUout;
endmodule
