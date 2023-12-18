module Mux_2(input [31:0] data0,
            input [31:0] data1,
            input select,
            output reg [31:0] out);

  always @(*)
  begin
    if (select == 1'b0)
      out = data0;
    else if (select == 1'b1)
      out = data1;
    else
      out=32'bx;
  end

endmodule