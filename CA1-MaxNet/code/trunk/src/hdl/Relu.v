module Relu(input [31:0] In,
            output Zero_sign,
            output reg [31:0] Out);

assign Out = In[31] ? 32'd0 : In;
assign Zero_sign = ~|Out;
endmodule