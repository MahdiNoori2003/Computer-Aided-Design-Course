module Finish (input Z_0,Z_1,Z_2,Z_3,
                output reg Finish);
                
    //checking if the program is finished
    assign Finish = (~Z_0&Z_1&Z_2&Z_3)|(Z_0&~Z_1&Z_2&Z_3)|(Z_0&Z_1&~Z_2&Z_3)|(Z_0&Z_1&Z_2&~Z_3)|(Z_0&Z_1&Z_2&Z_3);
endmodule