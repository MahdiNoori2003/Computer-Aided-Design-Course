module F_Adder (input [31:0]A,
                input [31:0]B,
                output reg  [31:0] result);

    reg [23:0] mantissa_A,mantissa_B;
    reg [23:0] mantissa_temp;
    reg [7:0] exponent,exponent_A,exponent_B,exponent_difference;
    reg carry ,sign_A,sign_B,comp;
    reg [7:0] exp_adjust;
    wire msb;
    always @(*)
        begin

            //checking if a is bigger than b
            comp =  (A[30:23] > B[30:23])? 1'b1 : 
                            (A[30:23] == B[30:23] && A[22:0] > B[22:0]) ? 1'b1 : 1'b0;

            //extracting each part of the fp
            mantissa_A = comp ? {1'b1,A[22:0]} : {1'b1,B[22:0]};
            exponent_A = comp ? A[30:23] : B[30:23];
            sign_A = comp ? A[31] : B[31];

            mantissa_B = comp ? {1'b1,B[22:0]} : {1'b1,A[22:0]};
            exponent_B = comp ? B[30:23] : A[30:23];
            sign_B = comp ? B[31] : A[31];

            // Check if A = -B
            if (sign_A != sign_B && mantissa_A == mantissa_B && exponent_A == exponent_B)
                result = 32'b0;
            else
            begin
                //adjusting the exponents
                exponent_difference = exponent_A-exponent_B;
                mantissa_B = (mantissa_B >> exponent_difference);
                {carry,mantissa_temp} =  (sign_A ~^ sign_B)? mantissa_A + mantissa_B : mantissa_A-mantissa_B ; 
                exp_adjust = exponent_A;

                //handling when carry normalization
                if(carry)
                    begin
                        mantissa_temp = mantissa_temp>>1;
                        exp_adjust = exp_adjust+1'b1;
                    end
                //normalizing denormalized numbers

                else
                    begin
                    while(!mantissa_temp[23])
                        begin
                           mantissa_temp = mantissa_temp<<1;
                           exp_adjust =  exp_adjust-1'b1;
                        end
                    end
                //producing the output
                exponent = exp_adjust;
                result = {sign_A,exponent,mantissa_temp[22:0]};
            end
    end
endmodule