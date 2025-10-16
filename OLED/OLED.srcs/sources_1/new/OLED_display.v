`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 17:02:32
// Design Name: 
// Module Name: OLED_display
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


module OLED_display (
    input clk,
    input rst_n,
    input display_en,
    input SPI_done, //SPI发送完成通知

    output       DC,         // 1数据 0命令
    output [7:0] SPI_data,   // SPI发送数据
    output       data_en,    // 数据使能
    output       SPI_en,
    output       display_done
    );

    // 状态机编码
    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;
    localparam S5 = 3'd5;
    localparam S6 = 3'd6;

    wire [11:0] addra;
    wire [7:0]  douta;

    // 状态机寄存器
    reg [2:0] cur_state;
    reg [2:0] nxt_state;

    reg [7:0] SPI_data_r;
    reg       SPI_en_r;
    reg       data_en_r;
    reg       DC_r;

    // page地址
    reg [7:0] x_temp;
    reg [7:0] y_temp;

    wire [7:0] Set_pos_0, Set_pos_1, Set_pos_2;
    assign Set_pos_0 = 8'hB0 | y_temp;      // PAGE地址
    assign Set_pos_1 = {4'h1, x_temp[7:4]}; // 高位列地址
    assign Set_pos_2 = {4'h0, x_temp[3:0]}; // 低位列地址
    assign display_done = (cur_state == S6) ? 1 : 0;

    assign SPI_data = SPI_data_r;
    assign data_en  = data_en_r;
    assign SPI_en   = SPI_en_r;
    assign DC       = DC_r;

    assign addra = {3'b000, y_temp} * 11'd128 + {3'b000, x_temp};

    rom_picture rom_picture_inst (
        .clka  (clk),
        .addra (addra),
        .douta (douta)
    );

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            x_temp <= 8'd0;
            y_temp <= 8'd0;
        end
        else
        begin
            case (cur_state)
                S0 :
                begin
                    x_temp <= 8'd0;
                    y_temp <= 8'd0;
                end
                S5 :
                begin
                    if (x_temp == 8'd127)
                    begin
                        x_temp <= 8'd0;
                        y_temp <= y_temp + 8'd1;
                    end
                    else
                    begin
                        x_temp <= x_temp + 8'd1;
                        y_temp <= y_temp;
                    end
                end
                default:
                begin
                    x_temp <= x_temp;
                    y_temp <= y_temp;
                end
            endcase
        end
    end

    // 状态转移
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            cur_state <= S0;
        end
        else
        begin
            cur_state <= nxt_state;
        end
    end

    always @(*)
    begin
        nxt_state = cur_state;

        case (cur_state)
            S0 : nxt_state = display_en ? S1 : S0;
            S1 :
            begin
                if (SPI_done)
                    nxt_state = S2;
            end
            S2 :
            begin
                if (SPI_done)
                    nxt_state = S3;
            end
            S3 :
            begin
                if (SPI_done)
                    nxt_state = S4;
            end
            S4 :
            begin
                if (SPI_done)
                    nxt_state = S5;
            end
            S5 :
            begin
                nxt_state = (x_temp == 127 && y_temp == 7) ? S6 : S1;
            end
            S6 : nxt_state = S0;
            default : nxt_state = S0;
        endcase
    end

    // 计算输出
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            SPI_data_r = 0;
            data_en_r  = 1'b0;
            SPI_en_r   = 1'b0;
            DC_r       = 1'b0;
        end
        else
        begin
            case (cur_state)
                S1 : 
                begin
                    SPI_data_r = Set_pos_0;
                    data_en_r  = 1'b1;
                    SPI_en_r   = 1'b1;
                    DC_r       = 1'b0;
                end
                S2 :
                begin
                    SPI_data_r = Set_pos_1;
                    data_en_r  = 1'b1;
                    SPI_en_r   = 1'b1;
                    DC_r       = 1'b0;
                end
                S3 :
                begin
                    SPI_data_r = Set_pos_2;
                    data_en_r  = 1'b1;
                    SPI_en_r   = 1'b1;
                    DC_r       = 1'b0;
                end
                S4 :
                begin
                    SPI_data_r = douta;
                    data_en_r  = 1'b1;
                    SPI_en_r   = 1'b0;
                    DC_r       = 1'b1;
                end
                default: 
                begin
                    SPI_data_r = 0;
                    data_en_r  = 1'b0;
                    SPI_en_r   = 1'b0;
                    DC_r       = 1'b0;
                end
            endcase
        end
    end

endmodule
