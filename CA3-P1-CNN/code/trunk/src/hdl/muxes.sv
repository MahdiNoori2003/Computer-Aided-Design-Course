module two_to_one_mux #(parameter WIDTH) ( input sel,
    input [WIDTH-1:0] data_0,data_1,
    output [WIDTH-1:0] data_out
);

    assign data_out = (sel == 1'b0) ? data_0 : 
                      (sel == 1'b1) ? data_1 :
                      {WIDTH {1'bx}};

endmodule
