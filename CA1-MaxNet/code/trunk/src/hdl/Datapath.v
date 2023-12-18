module Datapath(input clk,rst,sel,ld_memory,ld_reg,
                output finish,
                output reg [31:0]max_num);
                
    wire[31:0] X_0,X_1,X_2,X_3;
    wire[31:0] Muxout_0,Muxout_1,Muxout_2,Muxout_3;
    wire[31:0] T_0,T_1,T_2,T_3;
    wire[31:0] PUout_0,PUout_1,PUout_2,PUout_3;
    wire Z_0,Z_1,Z_2,Z_3;

    wire [31:0] W0, W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12, W13, W14, W15;

    //memory and buffer section
    Memory memory(clk, ld_memory, X_0, X_1,X_2, X_3);
    Buffer buffer(W0, W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12, W13, W14, W15);

    //muxes before X_i registers
    Mux_2 M1(PUout_0,X_0,sel,Muxout_0);
    Mux_2 M2(PUout_1,X_1,sel,Muxout_1);
    Mux_2 M3(PUout_2,X_2,sel,Muxout_2);
    Mux_2 M4(PUout_3,X_3,sel,Muxout_3);

    //X_i registers
    Register X0(Muxout_0,T_0,clk,rst,ld_reg);
    Register X1(Muxout_1,T_1,clk,rst,ld_reg);
    Register X2(Muxout_2,T_2,clk,rst,ld_reg);
    Register X3(Muxout_3,T_3,clk,rst,ld_reg);

    //PUs network
    Pu PU1(T_0, T_1, T_2, T_3, W0, W1, W2, W3, clk, rst, PUout_0 , Z_0);
    Pu PU2(T_0, T_1, T_2, T_3, W4, W5, W6, W7, clk, rst, PUout_1 , Z_1);
    Pu PU3(T_0, T_1, T_2, T_3, W8, W9, W10, W11, clk, rst, PUout_2 , Z_2);
    Pu PU4(T_0, T_1, T_2, T_3, W12, W13, W14, W15, clk, rst, PUout_3 , Z_3);

    Finish f(Z_0,Z_1,Z_2,Z_3,finish);

    //max_num return section
    wire[1:0] answer_idx;
    Encoder encoder(Z_0, Z_1, Z_2, Z_3, answer_idx);
    wire [31:0] maximum_number;
    Mux_4 M_res( X_0, X_1, X_2, X_3,answer_idx,maximum_number);
    assign max_num = maximum_number;
    
endmodule