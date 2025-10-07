`timescale 1ns/1ps

module fsm (
    input  clk,
    input  rst,
    input  a,
    input  b,
    output [2:0]out
);

    parameter wt    = 3'b000,
    
              sens1 = 3'b001,
              sens2 = 3'b010,
              
              sens3 = 3'b011,
              sens4 = 3'b100,
              
              enter = 3'b101,
              exit  = 3'b110;
            
    reg [2:0] nst, st;
    

    assign out = st;
   

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
                if (a & ~b)  nst = sens1;
                else if (b & ~a) nst = sens3;
            end

            sens1: begin
                if (a && b)  nst = sens2;
                else         nst = wt;
            end
            
            sens2: begin
                if (b & ~a)  nst = enter;
                else         nst = wt;
            end     
            
            sens3: begin
                if (b && a) nst = sens4;
                else        nst = wt;
            end
            
            sens4: begin
                if (a & ~b) nst = exit; 
                else        nst = wt;
            end
                                   
            enter: nst = wt;
            exit:  nst = wt;
            
            default: nst = wt;
        endcase
    end

endmodule
