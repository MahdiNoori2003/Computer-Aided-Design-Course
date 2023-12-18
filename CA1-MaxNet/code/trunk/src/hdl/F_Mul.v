module F_Mul (input [31:0]A,
              input [31:0]B,
              output reg  [31:0] result);

    reg [23:0] mantissa_A,mantissa_B;
    reg [22:0] mantissa;
    reg [47:0] mantissa_temp;
    reg [7:0] exponent_A,exponent_B,exponent_temp,exponent;
    reg sign_A,sign_B;
    reg [6:0] exp_adjust;
    always@(*)
        begin
            //extracting each part of the fp
            mantissa_A = {1'b1,A[22:0]};
            exponent_A = A[30:23];
            sign_A = A[31];

            mantissa_B = {1'b1,B[22:0]};
            exponent_B = B[30:23];
            sign_B = B[31];

            // calculating the result and adjusting the exponent
            exponent_temp = exponent_A+exponent_B-127;
            mantissa_temp = mantissa_A*mantissa_B;
            mantissa = mantissa_temp[47] ? mantissa_temp[46:24] : mantissa_temp[45:23];
            exponent = mantissa_temp[47] ? exponent_temp+1'b1 : exponent_temp;
            // if the input had zero we return zero
            result = (A == 32'b0 || B == 32'b0) ? 0 : {sign_A^sign_B,exponent,mantissa};
    end
endmodule