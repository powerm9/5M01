`timescale 1ns/1ps

module fsm (
    input  clk,
    input  rst,
    input  a,
    input  b,
    output out
);

    parameter wt     = 2'b00,
              sensa  = 2'b01,
              sensab = 2'b11,
              enter  = 2'b00,
              sensb  = 2'b01,
              sensba = 2'b11,
              exit   = 2'b00;

    reg [2:0] nst, st;

    assign out = (st == enter) | (st == exit);

    always @(posedge clk) begin
        if (rst)
            st <= wt;
        else
            st <= nst;
    end

    always @* begin
        nst = st;
        case (st)
            wt: begin
                if (a)       nst = sensa;
                else if (b)  nst = sensb;
            end

            sensa: begin
                if (a & b)  nst = sensab;
                else        nst = wt;
            end

            sensb: begin
                if (b & a)  nst = sensba;
                else        nst = wt;
            end

            sensba: begin
                if (~b & ~a) nst = exit;
            end

            sensab: begin
                if (~a & ~b) nst = enter;
            end

            enter: nst = wt;
            exit:  nst = wt;

            default: nst = wt;
        endcase
    end

endmodule
