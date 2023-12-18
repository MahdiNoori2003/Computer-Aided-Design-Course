module Memory(input clk, ld, 
            output reg [31:0] ReadData1, ReadData2, ReadData3, ReadData4); 

    reg [31:0] Memory[0:3];

    //loading data from file
    always @(ld) begin
        if (ld) $readmemh("./file/input.txt", Memory);
    end

    //returning memory values
    assign ReadData1 = Memory[0];
    assign ReadData2 = Memory[1];
    assign ReadData3 = Memory[2];
    assign ReadData4 = Memory[3];
    
endmodule
