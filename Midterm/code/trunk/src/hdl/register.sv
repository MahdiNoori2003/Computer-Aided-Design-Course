module register #(parameter WIDTH = 8)(input clk,rst,ld,
  input [WIDTH-1:0] data_in,
  output [WIDTH-1:0] data_out
);

  reg [WIDTH-1:0] register;

  always @(posedge clk,posedge rst) begin
    if (rst)
      register <= {WIDTH{1'b0}};
    if (ld)
      register <= data_in;
  end

  assign data_out = register;

endmodule