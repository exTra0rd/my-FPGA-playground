`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/11 21:31:14
// Design Name: 
// Module Name: new_tb
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


module new_tb();

    reg       clk;
    reg       rst_n;
    reg       en;
    reg       data_en;
    wire [7:0] user_data;
    wire       DC_in;

    wire SPI_MOSI;
    wire SPI_SCK;
    wire SPI_DC;
    wire SPI_DONE;

    reg done_signal;

    SPI_driver_new SPI_driver_new_inst (
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_en   (data_en),
        .user_data (user_data),
        .DC_in     (DC_in),
        .SPI_MOSI  (SPI_MOSI),
        .SPI_SCK   (SPI_SCK),
        .SPI_DC    (SPI_DC),
        .SPI_DONE  (SPI_DONE)
    );

    initial
    begin
        clk     = 0;
        rst_n   = 0;
        en      = 0;
        data_en = 0;
        #5;
        rst_n   = 1;
        #5;
        en      = 1;
        data_en = 1;
    end

    always
    begin
        #10 clk = ~clk;
    end

    assign user_data = 8'hAA;
    assign DC_in     = 1'b1;

    always @(posedge clk)
    begin
        if (SPI_DONE)
        begin
            done_signal <= 1'b1;
        end
        else
        begin
            done_signal <= 1'b0;
        end
    end

endmodule
