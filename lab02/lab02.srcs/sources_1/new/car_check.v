`timescale 1ns / 1ps

module car_check(
    input clk,
    input btn_a,
    input btn_b,
    input btn_rst,
    output [3:0] led
    );
    
    parameter enter = 3'b101, exit = 3'b110;
    
    wire [2:0] fsm_out;
    wire [3:0] count;
    wire btn_a_db;
    wire btn_b_db;
    wire btn_rst_db;
    
    reg inc, dec;

    assign led = count;
    
    debouncer dbcer0(.clk(clk), .reset(1'b0), .button(btn_a), .button_db(btn_a_db)); 
    debouncer dbcer1(.clk(clk), .reset(1'b0), .button(btn_b), .button_db(btn_b_db)); 
    debouncer dbcer2(.clk(clk), .reset(1'b0), .button(btn_rst), .button_db(btn_rst_db)); 
    
    fsm fsm(.clk(clk), .rst(btn_rst_db), .a(btn_a_db), .b(btn_b_db), .out(fsm_out));
    counter cnt(.clk(clk), .rst(btn_rst_db), .inc(inc), .dec(dec), .out(count));

    always @(posedge clk) begin
        if (fsm_out == enter) begin
            inc <= 1'b1;
            dec <= 1'b0;
        end
        else if (fsm_out == exit) begin
            inc <= 1'b0;
            dec <= 1'b1;
        end
        else begin
            inc <= 1'b0;
            dec <= 1'b0;
        end
        
    end
    
endmodule