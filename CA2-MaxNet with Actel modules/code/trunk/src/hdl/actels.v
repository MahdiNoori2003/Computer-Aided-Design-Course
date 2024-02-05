module Actel_C1(input A0, A1, SA, B0, B1, SB, S0, S1, 
    output F
);

    wire F1 = (SA) ? A1 : A0;
    wire F2 = (SB) ? B1 : B0;    
    assign F = (S0 | S1) ? F2 : F1;

endmodule

module Actel_C2 (input D00, D01, D10, D11, A1, B1, A0, B0, 
    output out
);

    wire S0 = A0 & B0;
    wire S1 = A1 | B1;
    assign out = ({S1, S0} == 2'b00) ? D00 :
                 ({S1, S0} == 2'b01) ? D01 :
                 ({S1, S0} == 2'b10) ? D10 :
                 ({S1, S0} == 2'b11) ? D11 : 'bz;

endmodule

module Actel_S1(input D00, D01, D10, D11, A1, B1, A0, CLR, CLK, 
    output reg out
);

    wire S0 = A0 & CLR;
    wire S1 = A1 | B1;
    wire[1:0] sel = {S1, S0};

    always @(posedge CLK, posedge CLR) begin
        if(CLR) begin 
            out <= 1'b0;
        end
        else begin
            case(sel)
                2'b00 : out <= D00;
                2'b01 : out <= D01;
                2'B10 : out <= D10;
                2'B11 : out <= D11;
            endcase
        end
    end

endmodule

module Actel_S2 (input CLK, CLR, D00, D01, D10, D11, A1, B1, A0, B0, 
    output reg out
);
    wire D;
    wire S0, S1;

    assign S0 = (A0 & B0);
    assign S1 = (A1 | B1);
    assign D = ({S1, S0} == 2'b00) ? D00 :
               ({S1, S0} == 2'b01) ? D01 :
               ({S1, S0} == 2'b10) ? D10 :
               ({S1, S0} == 2'b11) ? D11 : 1'bz;

    always @(posedge CLK) begin
        if(CLR)
            out = 0;
        else
            out = D;
    end

endmodule