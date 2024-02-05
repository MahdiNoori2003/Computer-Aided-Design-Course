module pe ( input clk, rst, filter_wr_en, mac_en, mac_clr, shift_reg_en, finalize_shift_reg,
  input [1:0] write_filter_buff_ind,
  input [3:0] pixel_ind, 
  input [7:0] pixel,
  input [7:0] mem_data_out[0:3],
  output [7:0] pe_out[0:3]
);

  wire [7:0] filter_buff_out;
  wire [11:0] mac_out;
  wire[7:0] mem_data_in[0:3];


  four_by_four_buffer FilterBuff(.data_in(mem_data_out), .wr_en(filter_wr_en),.clk(clk),.rst(rst), .rd_index(pixel_ind),
            .wr_index(({write_filter_buff_ind,2'b0})), .data_out(filter_buff_out));

  mac Mac(.clk(clk), .rst(rst), .reg_en(mac_en),.clr(mac_clr), .pixel(pixel), .weight(filter_buff_out), .result(mac_out));

  shift_register ShiftReg(.data_in(mac_out[11:4]), .clk(clk), .sh_en(shift_reg_en),.final_en(finalize_shift_reg), .data_out(pe_out));

endmodule


module new_pe #(parameter KERNEL_COUNT)(input clk, rst, window_wr_en, mac_en, mac_clr, shift_reg_en,
    input [7:0] filter_buff_inp[0:3],
    input [7:0] window_inp [0:KERNEL_COUNT-1][0:3],
    input [0:KERNEL_COUNT-1] filter_wr_en,
    input [3:0] rd_index,
    input [1:0] wr_index_filter_buff,wr_index_window,
    output [7:0] new_pe_out [0:3]
);

    wire [7:0] filter_buffs_out [0:KERNEL_COUNT-1];
    wire [7:0] windows_out [0:KERNEL_COUNT-1];
    wire [11:0] macs_out [0:KERNEL_COUNT-1];
    
    genvar i;
    generate
    for(i = 0; i < KERNEL_COUNT; i+=1)
        four_by_four_buffer FilterBuff(.data_in(filter_buff_inp), .wr_en(filter_wr_en[i]),.clk(clk),.rst(rst), .rd_index(rd_index),
            .wr_index(({wr_index_filter_buff,2'b0})), .data_out(filter_buffs_out[i]));
    endgenerate

    generate
    for(i = 0; i < KERNEL_COUNT; i+=1)
        four_by_four_buffer Window(.data_in(window_inp[i]), .wr_en(window_wr_en),.clk(clk),.rst(rst), .rd_index(rd_index),
            .wr_index(({wr_index_window,2'b0})), .data_out(windows_out[i]));
    endgenerate

    generate
    for(i = 0; i < KERNEL_COUNT; i+=1)
        mac Mac(.clk(clk), .rst(rst), .reg_en(mac_en),.clr(mac_clr), .pixel(windows_out[i]), .weight(filter_buffs_out[i]), .result(macs_out[i]));
    endgenerate

    wire [7:0] adder_out;
    adder_parametrized #(KERNEL_COUNT) Adder (.mac_outs(macs_out),.add_out(adder_out));
    
    shift_register ShiftReg(.data_in(adder_out), .clk(clk), .sh_en(shift_reg_en),.final_en(1'b0), .data_out(new_pe_out));

endmodule