module two_bit_counter(input clk,rst,en,
    output cout,
    output reg [1:0] count
);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 2'b00;
        end else if (en) begin
            count <= count + 1;
        end
    end

    assign cout = (count == 2'd3);

endmodule


module four_bit_counter(input clk,
    input rst,
    input en,
    output cout,
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (en) begin
            count <= count + 1;
        end
    end

    assign cout = (count == 4'd15);

endmodule



module counter_up_to_12(input clk,rst,en,
    output cout, 
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (en) begin
            if (count == 4'b1101) begin
                count <= 4'b0000; 
            end else begin
                count <= count + 1;
            end
        end
    end
    assign cout = (count == 4'd13);

endmodule


module counter_up_to_3(input clk, rst,en,
    output cout,
    output reg [1:0] count
);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 2'b01;
        end else if (en) begin
            count <= count + 1;
        end
    end

    assign cout = (count == 2'd4);

endmodule


module counter_up_to_43(input clk, rst, en,
  output cout,
  output reg [5:0] count
);

  always @(posedge clk , posedge rst) begin
    if (rst) begin
      count <= 0;
    end else begin
        if (en) count <= count + 1;
    end
  end
  assign cout = (count == 42);

endmodule


module parametrized_counter #(parameter COUNT) (input clk,rst,en,
    output reg [($clog2(COUNT)-1):0] count,
    output reg cout
);

    always @(posedge clk , posedge rst) begin
        if (rst) 
            count <= 0;
        if(en)begin
            if (count == (COUNT-1))
                count <= 0;
            else
                count <= count + 1;
        end
    end
    assign cout = (count == (COUNT-1));
endmodule
