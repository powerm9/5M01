`timescale 1ns / 1ps

module counter(
    input  clk,
    input  rst,
    input  inc,
    input  dec,
    output [3:0] out
    );
    
    reg [3:0] count;
    
    assign out = count;
    
    always @ (posedge clk) begin
        if (rst == 1'b1)
            count <= 4'b0;
        if (inc == 1'b1)
            count <= count + 1'b1;
        else if (dec == 1'b1)
            count <= count - 1'b1;
        end
             
endmodule
