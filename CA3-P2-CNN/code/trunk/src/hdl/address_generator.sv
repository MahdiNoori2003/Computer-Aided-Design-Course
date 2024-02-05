module address_generator (input clk, rst, en_window_start_pos_counter, en_line_counter,
    output [$clog2(172)-1:0] address,
    output cout_addr_generator, window_ld_done
);

    wire cout_i_counter,cout_j_counter,cout_line_counter;
    wire [$clog2(10)-1:0] count_i,count_j;
    wire [1:0] count_line;

    parametrized_counter #(10) Count_i (.clk(clk),.rst(rst),.en(cout_j_counter & en_window_start_pos_counter), .count(count_i),.cout(cout_i_counter));

    parametrized_counter #(10) Count_j (.clk(clk),.rst(rst),.en(en_window_start_pos_counter),.count(count_j),
    .cout(cout_j_counter));

    two_bit_counter CountLine(.clk(clk),.rst(rst),.en(en_line_counter), .cout(cout_line_counter),
    .count(count_line));

    assign address = (13 * (count_i + count_line)) + count_j ;
    assign cout_addr_generator = cout_line_counter;
    assign window_ld_done = cout_i_counter & cout_j_counter;

endmodule