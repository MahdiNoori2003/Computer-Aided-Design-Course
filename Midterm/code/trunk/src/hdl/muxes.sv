module two_to_one_mux( input sel,
    input [8:0] data_0,data_1,
    output [8:0] data_out
);

    assign data_out = (sel == 1'b0) ? data_0 : 
                      (sel == 1'b1) ? data_1 :
                      9'bx;

endmodule


module three_to_one_mux(input [1:0] sel,
    input [8:0] data_0, data_1, data_2,
    output reg [8:0] data_out
);

    always @(*)
        case (sel)
            2'b00: data_out = data_0;
            2'b01: data_out = data_1;
            2'b10: data_out = data_2;
            default: data_out = 9'bx;
        endcase

endmodule
