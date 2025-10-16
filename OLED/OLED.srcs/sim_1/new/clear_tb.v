`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/16 13:58:01
// Design Name: 
// Module Name: clear_tb
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


module clear_tb();

    reg clk;
    reg rst_n;

    wire DC;
    wire SPI_MOSI;
    wire SPI_SCK;

    clear_spi clear_spi_inst (
        .clk   (clk),
        .rst_n (rst_n),

        .SPI_MOSI (SPI_MOSI),
        .SPI_SCK  (SPI_SCK),
        .SPI_DC   (DC)
    );

    initial
    begin
        clk      = 0;
        rst_n    = 1;

        #2;
        rst_n = 0;
        #2;
        rst_n = 1;
    end

    always
    begin
        #10 clk = ~clk;
    end

endmodule
