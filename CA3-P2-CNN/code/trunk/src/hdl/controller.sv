module controller_cnn_layer1 #(parameter KERNEL_COUNT)(input clk,rst, start, cout_filter_write_index, cout_mac_index,cout_buff_write_index, cout_buff_read_index, 
  output reg en_x, en_y, en_z, en_buff,en_buff_read_index, 
  output reg[0:KERNEL_COUNT-1]en_filter, 
  output reg en_filter_write_index,en_window, en_mac_index, en_mac, en_buff_write_index, sh_en_buff, sh_en_reg,
  sel_x, sel_y, sel_z, wr_en_memory, done, clr_mac,finalize_shift_reg,sel_address_memory,sel_address_wr_layer1
);

   reg en1,en2,en3,en_kernel_counter;
   reg[1:0] count1;
   reg [5:0] count2;
   reg [1:0] count3;
   reg [($clog2(KERNEL_COUNT)-1):0] kernel_count;

   wire cout1,cout2,cout3,cout_kernel_counter;
   parameter [3:0] Idle=4'd0, Start=4'd1, Init=4'd2, FilterLd=4'd3, BuffWr=4'd4, BuffLd=4'd5, WindowLd=4'd6, Mac=4'd7, ShiftReg=4'd8, Decide=4'd9, MemWr=4'd10, EndDecide=4'd11, BuffRefill=4'd12,Finalize=4'd13,Done=4'd14,KernelLdDone=4'd15;

   two_bit_counter ShiftCount(.clk(clk), .rst(rst), .en(en1),
                   .cout(cout1), .count(count1));
   counter_up_to_43 WriteCount(.clk(clk), .rst(rst), .en(en2),
                   .cout(cout2), .count(count2));
   counter_up_to_3 BuffReadCount(.clk(clk), .rst(rst), .en(en3),
                   .cout(cout3), .count(count3));
   parametrized_counter #(KERNEL_COUNT) KernelCounter(.clk(clk), .rst(rst), .en(en_kernel_counter),
                   .cout(cout_kernel_counter), .count(kernel_count));
   reg [3:0] ns, ps;
   always @(ps, start, cout_filter_write_index, cout_mac_index, cout_buff_write_index, cout_buff_read_index, cout1, cout2, cout3) begin
           ns = Idle;
           case (ps)
                   Idle : ns = (start) ? Start : Idle;
                   Start : ns = (start) ? Start : Init;
                   Init : ns = FilterLd;
                   FilterLd : ns = (cout_filter_write_index) ? KernelLdDone : FilterLd;
                   KernelLdDone : ns = (cout_kernel_counter) ? BuffWr : FilterLd;
                   BuffWr : ns = (cout_buff_write_index) ? BuffLd : BuffWr;
                   BuffLd : ns = (cout3) ? WindowLd : BuffWr;
                   WindowLd : ns = Mac;
                   Mac : ns = (cout_mac_index) ? ShiftReg : Mac;
                   ShiftReg : ns = Decide;
                   Decide : begin 
                        if (cout1) ns = MemWr;
                        else if (~cout1 && cout_buff_read_index) ns = EndDecide;
                        else if (~cout1 && ~cout_buff_read_index) ns = WindowLd;
                        end
                   MemWr : ns = (cout_buff_read_index) ? EndDecide : WindowLd;
                   EndDecide : ns = (cout2) ? Finalize : BuffRefill;
                   BuffRefill : ns = (cout_buff_write_index) ? WindowLd : BuffRefill;
                   Finalize : ns = Done;
                   Done : ns = Idle;
                   default: ns = Idle;
           endcase
   end
   always @(ps) begin
           {en_x, en_y, en_z, en_buff,en_buff_read_index, en_filter, en_filter_write_index,en_window, en_mac_index, en_mac,en_buff_write_index, sh_en_buff, sh_en_reg,sel_x, sel_y, sel_z, wr_en_memory, done,sel_address_memory,en1,en2,en3,clr_mac,finalize_shift_reg,sel_address_wr_layer1} = {(24+(KERNEL_COUNT)){1'b0}};
           case(ps) 

                Init : begin
                        {en_x, en_y, en_z, sel_x, sel_y, sel_z} = 6'b111111;
                end
                FilterLd : begin
                        {sel_address_memory, en_y} = 2'b11;
                        en_filter_write_index=1'b1;
                        en_filter[kernel_count]=1'b1;
                end
                KernelLdDone : begin
                        en_kernel_counter=1'b1;
                end
                BuffWr : begin
                        {sel_address_memory, en_buff, en_buff_write_index, en_x} = 4'b0111;
                end
                BuffLd : begin
                        {en3} = 1'b1;
                        sh_en_buff=(cout3 == 1'b0);
                end
                WindowLd : begin
                        {en_window,en_buff_read_index} = 2'b11;
                end
                Mac : begin
                        {en_mac_index, en_mac} = 2'b11;
                end
                ShiftReg : begin
                        {sh_en_reg} = 1'b1;
                end
                Decide: begin
                        {en1,clr_mac} = 2'b11;
                end
                MemWr : begin
                        {wr_en_memory, en_z,en2,sel_address_wr_layer1} = 4'b1111;
                end
                EndDecide : begin
                        sh_en_buff = (cout2 == 1'b0);
                        {en_buff_read_index} = 1'b1;
                end

                BuffRefill:begin
                        {en_buff,sel_address_memory,en_x,en_buff_write_index} = 4'b1011;
                end
                Finalize:begin
                      {wr_en_memory,finalize_shift_reg,sel_address_wr_layer1} = 3'b111;
                end
                Done:begin
                      {done} = 1'b1;
                end
           endcase
   end
   always @(posedge clk, posedge rst) begin
           if (rst == 1'b1) begin
                   ps <= Idle;
           end
           else begin
                   ps <= ns;
           end
   end
endmodule



module controller_cnn_layer2 #(parameter KERNEL_COUNT)(input clk, rst, start, cout_filter_write_index,
    cout_addr_generator, cout_mac_index, window_ld_done,
    output reg [0:KERNEL_COUNT-1] en_filter,
    output reg en_pc_filter, write_filter_buff_counter_en, window_wr_en, addr_gen_line_counter_en, sel_mem,
    en_mac_index, en_mac, sh_en_reg, addr_gen_window_pos_counter_en, clr_mac,done, mem_wr_en, load_w
);

   reg en_kernel_counter,en_shift_counter;
   reg [($clog2(KERNEL_COUNT)-1):0] kernel_count;
   reg [1:0] shift_count;
   wire cout_kernel_counter, cout_shift_counter;
   parameter [3:0] Idle=4'd0, FilterLd=4'd1, WindowLd=4'd2, Mac=4'd3, ShiftReg=4'd4, Decide=4'd5, MemWr=4'd6,Done=4'd7,FilterLdDone=4'd8;

   two_bit_counter ShiftCount(.clk(clk), .rst(rst), .en(en_shift_counter),
                   .cout(cout_shift_counter), .count(shift_count));

   parametrized_counter #(KERNEL_COUNT) KernelCounter(.clk(clk), .rst(rst), .en(en_kernel_counter),
                   .cout(cout_kernel_counter), .count(kernel_count));

   reg [3:0] ns, ps;
   always @(ps, start, cout_filter_write_index, cout_mac_index, cout_kernel_counter, cout_shift_counter,window_ld_done,cout_addr_generator) begin
           ns = Idle;
           case (ps)
                   Idle : ns = (start) ? FilterLd : Idle;
                   FilterLd : ns = (cout_filter_write_index) ? FilterLdDone : FilterLd;
                   FilterLdDone : ns = (cout_kernel_counter) ? WindowLd : FilterLd;
                   WindowLd : ns = (cout_addr_generator) ? Mac : WindowLd;
                   Mac : ns = (cout_mac_index) ? ShiftReg : Mac;
                   ShiftReg : ns = Decide;
                   Decide : ns = (cout_shift_counter) ? MemWr : WindowLd;
                   MemWr : ns = (window_ld_done) ? Done : WindowLd;
                   Done : ns = Idle;
                   default: ns = Idle;
           endcase
   end
   
   always @(ps) begin
           {en_filter, en_pc_filter, write_filter_buff_counter_en, window_wr_en, addr_gen_line_counter_en, sel_mem,en_mac_index, en_mac, sh_en_reg, addr_gen_window_pos_counter_en,en_shift_counter,clr_mac,mem_wr_en, load_w, done} = {(13+(KERNEL_COUNT)){1'b0}};
           case(ps) 
                FilterLd : begin
                        {en_pc_filter, write_filter_buff_counter_en} = 2'b11;
                        en_filter[kernel_count]=1'b1;
                end
                FilterLdDone : begin
                        en_kernel_counter=1'b1;
                end
                WindowLd : begin
                        {window_wr_en,addr_gen_line_counter_en, sel_mem} = 3'b111;
                end
                Mac : begin
                        {en_mac_index, en_mac} = 2'b11;
                end
                ShiftReg : begin
                        {sh_en_reg} = 1'b1;
                end
                Decide: begin
                        addr_gen_window_pos_counter_en = (cout_shift_counter == 1'b0);
                        {en_shift_counter,clr_mac} = 2'b11;
                end
                MemWr : begin
                        {mem_wr_en, load_w, addr_gen_window_pos_counter_en} = 3'b111;
                end
                Done:begin
                      {done} = 1'b1;
                end
           endcase
   end
   always @(posedge clk, posedge rst) begin
           if (rst == 1'b1) begin
                   ps <= Idle;
           end
           else begin
                   ps <= ns;
           end
   end
endmodule

