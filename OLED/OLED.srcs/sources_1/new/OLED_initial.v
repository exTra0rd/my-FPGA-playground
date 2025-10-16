`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/15 15:24:18
// Design Name: 
// Module Name: OLED_initial
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


module OLED_initial(
    input clk,      // 时钟信号
    input rst_n,    // 复位信号
    input SPI_BUSY, // SPI完成信号
    input en,       // 初始化使能

    output       DC,           // 1 数据 0 命令
    output       initial_done, // 初始化完成信号
    output       SPI_en,       // SPI 使能
    output [7:0] SPI_data,     // SPI 发送的数据
    output       data_en
    );

    // 寄存器指令参数定义
    localparam Display_on        = 8'hAF; // 开启显示
    localparam Display_off       = 8'hAE; // 关闭显示
    localparam Set_display_clk_0 = 8'hD5; // 显示时钟分频控制命令头
    localparam Set_display_clk_1 = 8'h80; // 100帧/秒
    localparam Set_charge_pump_0 = 8'h8D; // 电荷泵 命令头
    localparam Set_charge_pump_1 = 8'h14; // 开启charge pump
    localparam Set_contrast_0    = 8'h81; // 对比度控制 命令头
    localparam Set_contrast_1    = 8'hCF; // 207
    localparam Set_precharge_0   = 8'hD9; // 预充电周期控制
    localparam Set_precharge_1   = 8'hF1; // 预充电 15clk 放电 1clk
    localparam Set_normal        = 8'hA6; // 正常显示
    localparam Set_inverse       = 8'hA7; // 反转显示

    // 状态机参数定义
    localparam IDLE        = 5'd0;
    localparam S0          = 5'd1;
    localparam S1          = 5'd2;
    localparam S2          = 5'd3;
    localparam S3          = 5'd4;
    localparam S4          = 5'd5;
    localparam S5          = 5'd6;
    localparam S6          = 5'd7;
    localparam S7          = 5'd8;
    localparam S8          = 5'd9;
    localparam S9          = 5'd10;
    localparam S10         = 5'd11;
    localparam S11         = 5'd12;
    localparam INITIAL_END = 5'd13;

    reg [4:0] cur_state; // 现态
    reg [4:0] nxt_state; // 次态

    reg       initial_done_r;
    reg       SPI_en_r;
    reg [7:0] SPI_data_r;
    reg       data_en_r;
 
    assign DC           = 1'b0;
    assign initial_done = initial_done_r;
    assign SPI_en       = SPI_en_r;
    assign SPI_data     = SPI_data_r;
    assign data_en      = data_en_r;

    // 状态转移
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) // 复位
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
                    nxt_state = S0;
                end
            end

            S0 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S1;
                end
            end

            S1 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S2;
                end
            end

            S2 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S3;
                end
            end

            S3 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S4;
                end
            end

            S4 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S5;
                end
            end

            S5 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S6;
                end
            end

            S6 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S7;
                end
            end

            S7 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S8;
                end
            end

            S8 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S9;
                end
            end

            S9 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S10;
                end
            end

            S10 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = S11;
                end
            end

            S11 :
            begin
                if (SPI_BUSY)
                begin
                    nxt_state = INITIAL_END;
                end
            end

            INITIAL_END :
            begin
                nxt_state = INITIAL_END;
            end

            default :
            begin
                nxt_state = IDLE;
            end
        endcase
    end

    // 计算输出
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            SPI_data_r     <=  'd0;
            initial_done_r <= 1'b0;
            SPI_en_r       <= 1'b0;
            data_en_r      <= 1'b0;
        end
        case (cur_state)
            IDLE :
            begin
                SPI_data_r     <= 0;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b0;
                data_en_r      <= 1'b0;
            end

            S0 :
            begin
                SPI_data_r     <= Display_off;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S1 :
            begin
                SPI_data_r     <= Set_display_clk_0;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S2 :
            begin
                SPI_data_r     <= Set_display_clk_1;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S3 :
            begin
                SPI_data_r     <= Set_charge_pump_0;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S4 :
            begin
                SPI_data_r     <= Set_charge_pump_1;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S5 :
            begin
                SPI_data_r     <= Set_contrast_0;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S6 :
            begin
                SPI_data_r     <= Set_contrast_1;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S7 :
            begin
                SPI_data_r     <= Set_precharge_0;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S8 :
            begin
                SPI_data_r     <= Set_precharge_1;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S9 :
            begin
                SPI_data_r     <= Set_inverse;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end

            S10 :
            begin
                SPI_data_r     <= Display_on;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b0;
                data_en_r      <= 1'b1;
            end

            S11 :
            begin
                SPI_data_r     <= 0;
                initial_done_r <= 1'b0;
                SPI_en_r       <= 1'b1;
                data_en_r      <= 1'b1;
            end
            
            INITIAL_END :
            begin
                SPI_data_r     <= 0;
                initial_done_r <= 1'b1;
                SPI_en_r       <= 1'b0;
                data_en_r      <= 1'b0;
            end
            default : SPI_data_r <= 0;
        endcase
    end

endmodule