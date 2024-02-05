module two_to_one_mux #(parameter WIDTH) ( input sel,
    input [WIDTH-1:0] data_0,data_1,
    output [WIDTH-1:0] data_out
);

    assign data_out = (sel == 1'b0) ? data_0 : 
                      (sel == 1'b1) ? data_1 :
                      {WIDTH {1'bx}};

endmodule


module two_to_one_mux_with_two_bit_sel #(parameter WIDTH) ( input [1:0] sel,
    input [WIDTH-1:0] data_0,data_1,
    output [WIDTH-1:0] data_out
);

    assign data_out = (sel == 2'd1) ? data_0 : 
                      (sel == 2'd2) ? data_1 :
                      {WIDTH {1'bx}};

endmodule
