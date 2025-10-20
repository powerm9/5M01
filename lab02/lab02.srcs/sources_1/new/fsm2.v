`timescale 1ns/1ps

module fsm (
    input  clk,
    input  rst,
    input  a,
    input  b,
    output [2:0]out
);
    //moore fsm, output only depends on the state
    //setup paramaters for each state
    
    parameter wt    = 3'b000,
    
              sens1 = 3'b001,
              sens2 = 3'b010,
              
              sens3 = 3'b011,
              sens4 = 3'b100,
              
              enter = 3'b101,
              exit  = 3'b110;
              
    // statest held in a reg       
    reg [2:0] nst, st;
    //assigning output to state
    assign out = st;
    
    //assign state at posiitve edge of clock
    always @(posedge clk) begin
        if (rst)
            st <= wt;
        else
            st <= nst;
    end

    always @* begin
        nst = st;
        case (st)
            wt:
                if (a & ~b)  nst = sens1;   //if just a go down enter path  
                else if (b & ~a) nst = sens3;   //if just b go down exit path
  
            sens1: 
                if (a && b)  nst = sens2; //both sensors continue enter path
                else if (a & ~b) nst = sens1;
                else         nst = wt;  //go back to wait if different input
                
            sens2: 
                if (b & ~a)  nst = enter; //if b and not a must be an entering car
                else if (a && b) nst = sens2; //still passing through so wait if car is still in the sensor
                else         nst = wt; //else go back to wait
                
            sens3: 
                if (b && a) nst = sens4; //same as sens1 buut for b path
                else if (b & ~a) nst = sens3; //car still passing through possibly
                else        nst = wt;
                
            sens4:
                if (a & ~b) nst = exit; //if a and not b must be exiting car
                else if (b && a) nst = sens4; //still passing through sometimes so wait if car is stuck in middle
                else        nst = wt; //else wait state again
                                   
            enter: nst = wt; //return to wait at end after enter and exit asserted
            exit:  nst = wt;
            
            default: nst = wt;
        endcase
    end

endmodule
