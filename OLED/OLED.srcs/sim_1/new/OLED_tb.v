`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/28 15:11:13
// Design Name: 
// Module Name: OLED_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OLED_tb (

    );

    reg sys_clk;
    reg sys_rst_n;

    wire OLED_D0;
    wire OLED_D1;
    wire OLED_RST;
    wire OLED_DC;

    OLED_TOP OLED_inst (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),

        .OLED_D0  (OLED_D0),
        .OLED_D1  (OLED_D1),
        .OLED_RST (OLED_RST),
        .OLED_DC  (OLED_DC)
    );

    initial
    begin
        sys_clk   = 1'b0;
        sys_rst_n = 1'b0;
        #40;
        sys_rst_n = 1'b1;
    end

    always
    begin
        #10 sys_clk = ~sys_clk;
    end

endmodule
