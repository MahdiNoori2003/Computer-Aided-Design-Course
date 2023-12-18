module controller(input clk,rst, start, cout_filter_write_index, cout_mac_index,cout_buff_write_index, cout_buff_read_index, 
  output reg en_x, en_y, en_z, en_buff,en_buff_read_index, en_filter, en_filter_write_index,en_window, en_mac_index, en_mac, en_buff_write_index, sh_en_buff, sh_en_reg,
  sel_x, sel_y, sel_z, wr_en_memory, done, clr_mac,finalize_shift_reg, 
  output reg [1:0] sel_address_memory
);

   reg en1,en2,en3;
   reg[1:0] count1;
   reg [5:0] count2;
   reg [1:0] count3;
   wire cout1,cout2,cout3;
   parameter [3:0] Idle=4'd0, Start=4'd1, Init=4'd2, FilterLd=4'd3, BuffWr=4'd4, BuffLd=4'd5, WindowLd=4'd6, Mac=4'd7, ShiftReg=4'd8, Decide=4'd9, MemWr=4'd10, EndDecide=4'd11, BuffRefill=4'd12,Done=4'd13;

   two_bit_counter ShiftCount(.clk(clk), .rst(rst), .en(en1),
                   .cout(cout1), .count(count1));
   counter_up_to_43 WriteCount(.clk(clk), .rst(rst), .en(en2),
                   .cout(cout2), .count(count2));
   counter_up_to_3 BuffReadCount(.clk(clk), .rst(rst), .en(en3),
                   .cout(cout3), .count(count3));
   reg [3:0] ns, ps;
   always @(ps, start, cout_filter_write_index, cout_mac_index, cout_buff_write_index, cout_buff_read_index, cout1, cout2, cout3) begin
           ns = Idle;
           case (ps)
                   Idle : ns = (start) ? Start : Idle;
                   Start : ns = (start) ? Start : Init;
                   Init : ns = FilterLd;
                   FilterLd : ns = (cout_filter_write_index) ? BuffWr : FilterLd;
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
                   EndDecide : ns = (cout2) ? Done : BuffRefill;
                   BuffRefill : ns = (cout_buff_write_index) ? WindowLd : BuffRefill;
                   Done : ns = Idle;
                   default: ns = Idle;
           endcase
   end
   always @(ps) begin
           {en_x, en_y, en_z, en_buff,en_buff_read_index, en_filter, en_filter_write_index,en_window, en_mac_index, en_mac,en_buff_write_index, sh_en_buff, sh_en_reg,sel_x, sel_y, sel_z, wr_en_memory, done,sel_address_memory,en1,en2,en3,clr_mac,finalize_shift_reg} = 25'd0;
           case(ps) 
                Idle:begin
                        {done} = 1'b1;
                end
                Init : begin
                        {en_x, en_y, en_z, sel_x, sel_y, sel_z} = 6'b111111;
                end
                FilterLd : begin
                        {sel_address_memory, en_y, en_filter_write_index, en_filter} = 5'b01111;
                end
                BuffWr : begin
                        {sel_address_memory, en_buff, en_buff_write_index, en_x} = 5'b00111;
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
                        {wr_en_memory, sel_address_memory, en_z,en2} = 5'b11011;
                end
                EndDecide : begin
                        sh_en_buff = (cout2 == 1'b0);
                        {en_buff_read_index} = 1'b1;
                end

                BuffRefill:begin
                        {en_buff,sel_address_memory,en_x,en_buff_write_index} = 5'b10011;
                end
                Done:begin
                      {wr_en_memory,sel_address_memory,finalize_shift_reg} = 4'b1101;
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
