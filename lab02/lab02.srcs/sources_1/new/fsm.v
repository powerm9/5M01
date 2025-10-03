`timescale 1ns/1ps


module seqdet (
    input clk, rst, a, b, 
    output out
    );
    
parameter wt = 2'b00, sensa = 2'b01, sensab = 2'b11, 
          enter = 2'b00, sensb = 2'b01, sensba = 2'b11, exit = 2'b00;
          
reg [2:0] nst, st;
assign out = (st == enter) | (st == exit);

always @ (posedge clk) begin
    if (rst) st <= wt;
    else st <= nst;
end

always @ *
    begin
    nst = st;
    case(st)
        wt: if(a) nst = sensa;
            else if(b) nst = sensb;
            
     sensa: if(a & b)
                nst = sensab;
                else nst = wt;
                
     sensb: if(b & a)
                nst = sensba;
                else nst = wt;     
                
    sensba: if(~b&~a)
                nst = exit;
                
    sensab: if(~a&~b)
                nst = enter;
                
     enter:    
            nst = wt;         
       
     exit:
            nst = wt;
           
        default: nst = wt;
    endcase
    end
endmodule