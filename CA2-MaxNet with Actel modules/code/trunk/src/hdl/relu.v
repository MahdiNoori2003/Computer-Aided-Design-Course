module Relu(
    input [11:0] in,
    output [4:0] out
);

    two_to_one_mux_parametrized #(5) muxInActvtFunc (.a({in[11],in[6:3]}), .b(5'd0), .sel(in[11]),.out(out));

endmodule