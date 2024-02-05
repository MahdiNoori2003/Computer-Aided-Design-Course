module Register #(parameter WIDTH = 5)(
    input clk , rst , en,
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reg_loop
            Actel_S2 c2(
                .out(out[i]),
                .D00(out[i]), .D01(1'bz), 
                .D10(data_in[i]), .D11(1'bz), 
                .A1(en),      .B1(1'b0), 
                .A0(1'b0),    .B0(1'b0), 
                .CLR(rst),    .CLK(clk) 
            );
        end
    endgenerate

endmodule


module Buffer (
    input clk,rst,
    output [4:0] W0,W1,W2,W3,W4,W5,W6,W7,W8,W9,W10,W11,W12,W13,W14,W15
);

    Register#(5) reg1 (.data_in(5'b01000) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W0));
    Register#(5) reg2 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W1));
    Register#(5) reg3 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W2));
    Register#(5) reg4 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W3));
    
    Register#(5) reg5 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W4));
    Register#(5) reg6 (.data_in(5'b01000) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W5));
    Register#(5) reg7 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W6));
    Register#(5) reg8 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W7));
    
    Register#(5) reg9 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W8));
    Register#(5) reg10 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W9));
    Register#(5) reg11 (.data_in(5'b01000) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W10));
    Register#(5) reg12 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W11));
    
    Register#(5) reg13 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W12));
    Register#(5) reg14 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W13));
    Register#(5) reg15 (.data_in(5'b11110) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W14));
    Register#(5) reg16 (.data_in(5'b01000) , .clk(clk) , .rst(1'b0) , .en(rst) , .out(W15));
    
endmodule
