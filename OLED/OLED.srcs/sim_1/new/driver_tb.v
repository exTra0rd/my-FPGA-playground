`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/18 17:08:14
// Design Name: 
// Module Name: driver_tb
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


module driver_tb();

    reg       clk;
    reg       rst_n;
    reg       en;
   wire  [7:0] user_data;

    wire SPI_MOSI;
    wire SPI_SCK;
    wire SPI_DC;
    wire SPI_BUSY;

    SPI_driver  SPI_driver_inst (
        .clk(clk),             // ϵͳʱ��
        .rst_n(rst_n),         // ��λ�ź�
        .en(en),               // ʹ���ź�
        .user_data(user_data), // ����������

        .SPI_MOSI(SPI_MOSI),   // SPI������
        .SPI_SCK(SPI_SCK),     // SPIʱ����
        .SPI_DC(SPI_DC),       // ���������
        .SPI_BUSY(SPI_BUSY)    // ���ݴ�������ź�
    );

    assign user_data  =  8'hAA;

    initial
    begin
        clk   = 0;
        rst_n = 0;
        en    = 0;
        #5;
        rst_n = 1;
        #5;
        en    = 1;
        #30;
        en = 0;
    end

    always
    begin
        #10 clk = ~clk;
    end

endmodule
