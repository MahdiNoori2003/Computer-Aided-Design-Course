module Buffer (
  output reg [31:0] W0,
  output reg [31:0] W1,
  output reg [31:0] W2,
  output reg [31:0] W3,
  output reg [31:0] W4,
  output reg [31:0] W5,
  output reg [31:0] W6,
  output reg [31:0] W7,
  output reg [31:0] W8,
  output reg [31:0] W9,
  output reg [31:0] W10,
  output reg [31:0] W11,
  output reg [31:0] W12,
  output reg [31:0] W13,
  output reg [31:0] W14,
  output reg [31:0] W15
);
  reg [31:0] buffer [0:15];

  //buffer initialization
  integer k, l;
  initial begin
    for (k = 0; k <= 3; k = k + 1) begin
      for (l = 0; l <= 3; l = l + 1) begin
        if (k == l)
          buffer[k*4+l] = 32'b00111111100000000000000000000000; // 1.0 in IEEE 754 format
        else
          buffer[k*4+l] = 32'b10111110010011001100110011001101; // -0.2 in IEEE 754 format
      end
    end
  end

  //setting outputs
  assign W0 = buffer[0];
  assign W1 = buffer[1];
  assign W2 = buffer[2];
  assign W3 = buffer[3];
  assign W4 = buffer[4];
  assign W5 = buffer[5];
  assign W6 = buffer[6];
  assign W7 = buffer[7];
  assign W8 = buffer[8];
  assign W9 = buffer[9];
  assign W10 = buffer[10];
  assign W11 = buffer[11];
  assign W12 = buffer[12];
  assign W13 = buffer[13];
  assign W14 = buffer[14];
  assign W15 = buffer[15];

endmodule