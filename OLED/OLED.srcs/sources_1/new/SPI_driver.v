`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/18 12:02:17
// Design Name: 
// Module Name: SPI_driver
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


module SPI_driver (
    input       clk,       // 系统时钟
    input       rst_n,     // 复位信号
    input       en,        // 使能信号
    input [7:0] user_data, // 待发送数据
    input       DC_in,

    output SPI_MOSI,       // SPI数据线
    output SPI_SCK,        // SPI时钟线
    output SPI_DC,         // 命令或数据
    output SPI_BUSY        // SPI 繁忙信号
    );

    // reg 信号定义
    reg [7:0] data_send;

    // 输出寄存器
    reg SPI_MOSI_r;
    reg SPI_SCK_r;
    reg SPI_BUSY_r;

    reg       SCK_cnt;  // 指示 SCK 的上升沿和下降沿
    reg [3:0] DATA_cnt; // 记录当前发送的数据位数

    // wire 信号定义

    // 状态机定义
    localparam IDLE = 2'b00;
    localparam WAIT = 2'b01;
    localparam SEND = 2'b10;

    reg [1:0] cur_state;
    reg [1:0] nxt_state;

    // assign 赋值
    assign SPI_MOSI = SPI_MOSI_r;
    assign SPI_SCK  = SPI_SCK_r;
    assign SPI_DC   = DC_in;
    assign SPI_BUSY = SPI_BUSY_r;

    // 三段式状态机

    // 状态转换
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            cur_state <= IDLE;
        end
        else
        begin
            cur_state <= nxt_state;
        end
    end

    // 计算次态
    always @(*)
    begin
        nxt_state = cur_state;

        case (cur_state)
            IDLE :
            begin
                if (en)
                begin
                    nxt_state = WAIT;
                end
            end

            WAIT :
            begin
                nxt_state = SEND;
            end

            SEND :
            begin
                if (DATA_cnt == 'd8) // 发完，次态为空闲
                begin
                    nxt_state = IDLE;
                end
            end
            default:
            begin
                nxt_state = IDLE;
            end
        endcase
    end

    // 控制输出
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            // 复位，全为 0
            SPI_MOSI_r <= 'b0;
            SPI_SCK_r  <= 'b1;
            SPI_BUSY_r <= 'b0;

            DATA_cnt   <= 'b0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    SPI_MOSI_r <= 'b0;
                    SPI_SCK_r  <= 'b1;
                    SPI_BUSY_r <= 'b0;

                    DATA_cnt   <= 'd0;
                end

                WAIT :
                begin
                    SPI_MOSI_r <= data_send[7];
                    SPI_SCK_r  <= 'b0;
                    SPI_BUSY_r <= 'b1;

                    DATA_cnt   <= 'd1;
                end

                SEND :
                begin
                    if(SCK_cnt) // 在 SCK 下降沿时，将 data_send 最高位赋给 MOSI
                    begin
                        SPI_MOSI_r <= data_send[7];
                        DATA_cnt   <= DATA_cnt + 'd1;
                    end
                    SPI_SCK_r <= ~SPI_SCK_r; // 对 clk 二分频，得到 SCK
                    SPI_BUSY_r <= 'b1;       // SEND 时，BUSY 信号置一
                end
                default: begin end
            endcase
        end
    end

    // 控制用户数据
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            data_send <= 8'b0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    if (en)
                    begin
                        data_send <= user_data;
                    end
                end

                WAIT :
                begin
                    data_send <= data_send;
                end

                SEND :
                begin
                    if (!SCK_cnt)
                    begin
                        data_send <= data_send << 1; // 在 SCK 上升沿时，左移
                    end
                end

                default : begin end
            endcase
        end
    end

    // 记录 SCK 的上下边沿
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            SCK_cnt <= 'b0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    SCK_cnt <= 'b0;
                end

                WAIT :
                begin
                    SCK_cnt <= 'b0;
                end

                SEND :
                begin
                    SCK_cnt <= SCK_cnt + 1;
                end
                default: begin end
            endcase
        end
    end

endmodule
