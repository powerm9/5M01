`timescale 1ns / 1ps

module counter(
    input  clk,
    input  rst,
    input  inc,
    input  dec,
    output [3:0] out
    );
    
    //store count in a reg
    reg [3:0] count;
    
    //set output as that reg value
    assign out = count;
    
    //setup the counter in always block
    always @ (posedge clk) begin
        if (rst == 1'b1)
            count <= 4'b0; //if reset set counter to 0 synchronously
        if (inc == 1'b1)
            count <= count + 1'b1;      //add if incremenet set from the fsm output being enter
        else if (dec == 1'b1)
            count <= count - 1'b1;     //subtract if decrement set from fsm output being exit
        end
             
endmodule
