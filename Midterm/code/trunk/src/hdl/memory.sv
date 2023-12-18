module memory (input clk, wr_en,done,
    input[8:0] addr,initial_wr_addr,
    input[7:0] data_in [0:3], 
    output [7:0] data_out [0:3]
);

    reg [31:0] memory [0:511];     
    // reads from input
    initial begin
        $readmemh ("./file/test1234.txt ", memory);
    end

    always @(posedge clk) begin
        if (wr_en)
            memory[(addr>>2)] <= {data_in[0],data_in[1],data_in[2],data_in[3]};
    end

    assign data_out[3] = memory [(addr >> 2)][7:0];
    assign data_out[2] = memory [(addr >> 2)][15:8];
    assign data_out[1] = memory [(addr >> 2)][23:16];
    assign data_out[0] = memory [(addr >> 2)][31:24];

    // writes the output to file
    reg [63:0] hex_char;

    always @(done) begin
        if (done)begin
            integer i;
            integer file;
		    file = $fopen("memory.txt", "w");

   	 	    for (i = 0; i < 43; i = i + 1) begin
      	    		$sformat(hex_char, "%h", memory[(initial_wr_addr >> 2)+i]); 
      	    		$fwrite(file, "%s\n", hex_char);
    	    	end

    	    	$fclose(file); 
  	    end
    end


endmodule