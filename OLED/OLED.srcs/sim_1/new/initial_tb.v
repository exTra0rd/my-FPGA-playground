`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/15 17:17:06
// Design Name: 
// Module Name: initial_tb
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


module initial_tb();

    reg clk;
    reg rst_n;
    reg SPI_BUSY;

    wire       DC;
    wire       initial_done;
    wire       SPI_en;
    wire [7:0] SPI_data;

    OLED_initial OLED_inst(
        .clk      (clk),
        .rst_n    (rst_n),
        .SPI_BUSY (SPI_BUSY),
        .en       (1'b1),

        .DC           (DC),
        .initial_done (initial_done),
        .SPI_en       (SPI_en),
        .SPI_data     (SPI_data)
    );

    initial
    begin
        clk   = 0;
        rst_n = 0;
        #20;
        rst_n = 1;
    end

    initial
    begin
        SPI_BUSY = 0;
        #20;
        SPI_BUSY = 1;
        #80;
        SPI_BUSY = 0;
    end

    always
    begin
        #5 clk = ~clk;
    end

endmodule
