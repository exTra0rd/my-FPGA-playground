`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/12 19:28:11
// Design Name: 
// Module Name: clear_spi
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


module clear_spi (
    input clk,
    input rst_n,

    output SPI_MOSI,
    output SPI_SCK,
    output SPI_DC
    );

    wire       DC_wire;
    wire       data_en_wire;
    wire       SPI_DONE_wire;
    wire [7:0] user_data_wire;
    wire       SPI_en_wire;

    SPI_driver_new SPI_driver_new_inst (
        .clk       (clk),            // 系统时钟
        .rst_n     (rst_n),          // 复位信号
        .en        (SPI_en_wire),    // 使能信号
        .data_en   (data_en_wire),   // 数据使能
        .user_data (user_data_wire), // 待发送数据
        .DC_in     (DC_wire),

        .SPI_MOSI (SPI_MOSI),     // SPI数据线
        .SPI_SCK  (SPI_SCK),      // SPI时钟线
        .SPI_DC   (SPI_DC),       // 命令或数据
        .SPI_DONE (SPI_DONE_wire) // SPI 一帧传送完成信号
    );

    OLED_clear OLED_clear_inst(
        .clk      (clk),
        .rst_n    (rst_n),
        .clear_en (1'b1),             //清零使能信号
        .SPI_done (SPI_DONE_wire),    //SPI发送完成通知

        .DC         (DC_wire),        // 1数据 0命令
        .clear_done (),               // 清零完成信号
        .SPI_data   (user_data_wire), // SPI发送数据
        .data_en    (data_en_wire),
        .SPI_en     (SPI_en_wire)
    );

endmodule
