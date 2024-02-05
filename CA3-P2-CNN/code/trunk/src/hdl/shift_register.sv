module shift_register(input clk,sh_en,final_en,
  input [7:0] data_in,
  output reg [7:0] data_out [0:3]
);

  reg [31:0] shift_reg;

  always @(posedge clk) begin
    if (sh_en) shift_reg <= {shift_reg[23:0], data_in};
  end

  always @(*) begin
    // produces the desired output for the final round

    if (final_en)begin
      data_out[0] = shift_reg[7:0];
      data_out[1] = 8'd0;
      data_out[2] = 8'd0;
      data_out[3] = 8'd0;
    end
    else begin
      data_out[0] = shift_reg[31:24];
      data_out[1] = shift_reg[23:16];
      data_out[2] = shift_reg[15:8];
      data_out[3] = shift_reg[7:0];
    end
  end
endmodule