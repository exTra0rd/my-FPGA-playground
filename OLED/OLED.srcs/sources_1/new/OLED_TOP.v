`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/15 14:56:55
// Design Name: 
// Module Name: OLED_TOP
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


module OLED_TOP (
    input sys_clk,   //系统时钟 50MHz
    input sys_rst_n, //系统复位

    output OLED_D0,  // 同步时钟：SPI_SCK
    output OLED_D1,  // 数据线：MOSI
    output OLED_RST, // OLED清屏信号 低电平有效
    output OLED_DC   // 1数据 0命令
   );

    // 状态机编码
    localparam RESET   = 3'd0;
    localparam INITIAL = 3'd1;
    localparam CLEAR   = 3'd2;
    localparam DISPLAY = 3'd3;
    localparam IDLE    = 3'd4;

    // 复位时间
    localparam rst_cnt_num = 'd5_000_000; //5_000_000

    reg [23:0] rst_cnt; // 复位计时计数器

    reg [2:0] cur_state;
    reg [2:0] nxt_state;

    reg OLED_D0_r;
    reg OLED_D1_r;
    reg OLED_RST_r;
    reg OLED_DC_r;

    assign OLED_D0  = OLED_D0_r;
    assign OLED_D1  = OLED_D1_r;
    assign OLED_RST = OLED_RST_r;
    assign OLED_DC  = OLED_DC_r;

    // initial 模块例化连线
    wire       initial_DC_wire;
    wire       initial_done_wire;
    wire       initial_SPI_en_wire;
    wire [7:0] initial_SPI_data_wire;
    wire       initial_data_en_wire;
    
    reg        initial_en_wire;

    // SPI 驱动模块例化连线
    reg       SPI_en_wire;
    reg       SPI_data_en_wire;
    reg [7:0] SPI_user_data_wire;
    reg       SPI_DC_in_wire;

    wire SPI_MOSI_wire;
    wire SPI_SCK_wire;
    wire SPI_DC_wire;
    wire SPI_DONE_wire;

    // clear 模块例化连线
    reg clear_en_wire;

    wire       clear_DC_wire;
    wire       clear_done_wire;
    wire [7:0] clear_SPI_data_wire;
    wire       clear_data_en_wire;
    wire       clear_SPI_en_wire;

    // display 模块例化连线
    reg display_en_wire;

    wire       display_DC_wire;
    wire [7:0] display_SPI_data_wire;
    wire       display_data_en_wire;
    wire       display_SPI_en_wire;
    wire       display_done_wire;

    // 模块例化

    // OLED 初始化模块
    OLED_initial OLED_initial_inst (
        .clk      (sys_clk),       // 时钟信号
        .rst_n    (sys_rst_n),     // 复位信号
        .SPI_BUSY (SPI_DONE_wire), // SPI完成信号
        .en       (initial_en_wire),    // 初始化使能

        .DC           (initial_DC_wire),       // 1 数据 0 命令
        .initial_done (initial_done_wire),     // 初始化完成信号
        .SPI_en       (initial_SPI_en_wire),   // SPI 使能
        .SPI_data     (initial_SPI_data_wire), // SPI 发送的数据
        .data_en      (initial_data_en_wire)
    );

    // SPI 驱动模块
    SPI_driver_new SPI_driver_new_inst (
        .clk       (sys_clk),            // 系统时钟
        .rst_n     (sys_rst_n),          // 复位信号
        .en        (SPI_en_wire),        // 使能信号
        .data_en   (SPI_data_en_wire),   // 数据使能
        .user_data (SPI_user_data_wire), // 待发送数据
        .DC_in     (SPI_DC_in_wire),

        .SPI_MOSI (SPI_MOSI_wire), // SPI数据线
        .SPI_SCK  (SPI_SCK_wire),  // SPI时钟线
        .SPI_DC   (SPI_DC_wire),   // 命令或数据
        .SPI_DONE (SPI_DONE_wire)  // SPI 一帧传送完成信号
    );

    // clear 模块
    OLED_clear OLED_clear_inst (
        .clk      (sys_clk),
        .rst_n    (sys_rst_n),
        .clear_en (clear_en_wire), //清零使能信号
        .SPI_done (SPI_DONE_wire), //SPI发送完成通知

        .DC         (clear_DC_wire),       // 1数据 0命令
        .clear_done (clear_done_wire),     // 清零完成信号
        .SPI_data   (clear_SPI_data_wire), // SPI发送数据
        .data_en    (clear_data_en_wire),  // 数据使能
        .SPI_en     (clear_SPI_en_wire)
    );

    // display 模块
    OLED_display OLED_display_inst (
            .clk          (sys_clk),
            .rst_n        (sys_rst_n),
            .display_en   (display_en_wire),
            .SPI_done     (SPI_DONE_wire),  //SPI发送完成通知

            .DC           (display_DC_wire),       // 1数据 0命令
            .SPI_data     (display_SPI_data_wire), // SPI发送数据
            .data_en      (display_data_en_wire),  // 数据使能
            .SPI_en       (display_SPI_en_wire),
            .display_done (display_done_wire)
    );

    // 状态转移
    always @(posedge sys_clk or negedge sys_rst_n)
    begin
        if (!sys_rst_n)
        begin
            cur_state <= RESET;
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
            RESET :
            begin
                if (rst_cnt == rst_cnt_num)
                begin
                    nxt_state = INITIAL;
                end
            end

            INITIAL :
            begin
                if (initial_done_wire)
                begin
                    nxt_state = CLEAR;
                end
            end

            CLEAR :
            begin
                if (clear_done_wire)
                begin
                    nxt_state = DISPLAY;
                end
            end

            DISPLAY :
            begin
                if (display_done_wire)
                begin
                    nxt_state = IDLE;
                end
            end

            IDLE :
            begin
                nxt_state = IDLE;
            end

            default :
            begin
                nxt_state = RESET;
            end
        endcase
    end

    // 计算输出
    always @(posedge sys_clk or negedge sys_rst_n)
    begin
        if (!sys_rst_n)
        begin
            SPI_en_wire        <= 1'b0;
            SPI_data_en_wire   <= 1'b0;
            SPI_user_data_wire <= 8'b0000_0000;
            SPI_DC_in_wire     <= 1'b0;

            OLED_D0_r       <= 1'b1;
            OLED_D1_r       <= 1'b0;
            OLED_RST_r      <= 1'b1;
            OLED_DC_r       <= 1'b0;

            initial_en_wire <= 1'b0;
            clear_en_wire   <= 1'b0;
            display_en_wire <= 1'b0;
        end
        else
        begin
            case (cur_state)
                RESET :
                begin
                    SPI_en_wire        <= 1'b0;
                    SPI_data_en_wire   <= 1'b0;
                    SPI_user_data_wire <= 8'b0000_0000;
                    SPI_DC_in_wire     <= 1'b0;

                    OLED_D0_r          <= 1'b1;
                    OLED_D1_r          <= 1'b0;
                    OLED_RST_r         <= 1'b0;
                    OLED_DC_r          <= 1'b0;

                    initial_en_wire    <= 1'b0;
                    clear_en_wire      <= 1'b0;
                    display_en_wire    <= 1'b0;
                end

                INITIAL :
                begin
                    SPI_en_wire        <= initial_SPI_en_wire;
                    SPI_data_en_wire   <= initial_data_en_wire;
                    SPI_user_data_wire <= initial_SPI_data_wire;
                    SPI_DC_in_wire     <= initial_DC_wire;

                    OLED_D0_r          <= SPI_SCK_wire;
                    OLED_D1_r          <= SPI_MOSI_wire;
                    OLED_RST_r         <= 1'b1;
                    OLED_DC_r          <= SPI_DC_wire;

                    initial_en_wire    <= 1'b1;
                    clear_en_wire      <= 1'b0;
                    display_en_wire    <= 1'b0;
                end

                CLEAR :
                begin
                    SPI_en_wire        <= clear_SPI_en_wire;
                    SPI_data_en_wire   <= clear_data_en_wire;
                    SPI_user_data_wire <= clear_SPI_data_wire;
                    SPI_DC_in_wire     <= clear_DC_wire;

                    OLED_D0_r          <= SPI_SCK_wire;
                    OLED_D1_r          <= SPI_MOSI_wire;
                    OLED_RST_r         <= 1'b1;
                    OLED_DC_r          <= SPI_DC_wire;

                    initial_en_wire    <= 1'b0;
                    clear_en_wire      <= 1'b1;
                    display_en_wire    <= 1'b0;
                end

                DISPLAY :
                begin
                    SPI_en_wire        <= display_SPI_en_wire;
                    SPI_data_en_wire   <= display_data_en_wire;
                    SPI_user_data_wire <= display_SPI_data_wire;
                    SPI_DC_in_wire     <= display_DC_wire;

                    OLED_D0_r          <= SPI_SCK_wire;
                    OLED_D1_r          <= SPI_MOSI_wire;
                    OLED_RST_r         <= 1'b1;
                    OLED_DC_r          <= SPI_DC_wire;

                    initial_en_wire    <= 1'b0;
                    clear_en_wire      <= 1'b0;
                    display_en_wire    <= 1'b1;
                end

                IDLE :
                begin
                    SPI_en_wire        <= 1'b0;
                    SPI_data_en_wire   <= 1'b0;
                    SPI_user_data_wire <= 8'b0000_0000;
                    SPI_DC_in_wire     <= 1'b0;

                    OLED_D0_r          <= 1'b1;
                    OLED_D1_r          <= 1'b0;
                    OLED_RST_r         <= 1'b1;
                    OLED_DC_r          <= 1'b0;

                    initial_en_wire    <= 1'b0;
                    clear_en_wire      <= 1'b0;
                end

                default :
                begin
                    SPI_en_wire        <= 1'b0;
                    SPI_data_en_wire   <= 1'b0;
                    SPI_user_data_wire <= 8'b0000_0000;
                    SPI_DC_in_wire     <= 1'b0;

                    OLED_D0_r          <= 1'b1;
                    OLED_D1_r          <= 1'b0;
                    OLED_RST_r         <= 1'b1;
                    OLED_DC_r          <= 1'b0;

                    initial_en_wire    <= 1'b0;
                    clear_en_wire      <= 1'b0;
                end
            endcase
        end
    end

    // 复位计时
    always @(posedge sys_clk or negedge sys_rst_n)
    begin
        if (!sys_rst_n)
        begin
            rst_cnt <= 'd0;
        end
        else
        begin
            case (cur_state)
                RESET :
                begin
                    rst_cnt <= rst_cnt + 'd1;
                end
                default: begin end
            endcase
        end
    end
    
endmodule

//    localparam rst_cnt_num = 'd5_000_000;

//     wire [7:0] SPI_data_wire;
//     wire       SPI_en_wire;
//     wire       SPI_DC_wire;
//     wire       SPI_BUSY_wire;
    
//     wire data_en;

//     reg        OLED_RST_r;
//     reg [23:0] rst_cnt;
//     reg        OLED_en;

//     assign OLED_RST = OLED_RST_r;

//     always @(posedge sys_clk or negedge sys_rst_n)
//     begin
//         if (!sys_rst_n)
//         begin
//             OLED_RST_r <= 1'b1;
//             OLED_en    <= 1'b0;
//         end
//         else
//         begin
//             if (rst_cnt < rst_cnt_num)
//             begin
//                 OLED_RST_r <= 1'b0;
//                 OLED_en    <= 1'b0;
//             end
//             else
//             begin
//                 OLED_RST_r <= 1'b1;
//                 OLED_en    <= 1'b1;
//             end
//         end
//     end

//     always @(posedge sys_clk or negedge sys_rst_n)
//     begin
//         if (!sys_rst_n)
//         begin
//             rst_cnt = 'd0;
//         end
//         else
//         begin
//             if (rst_cnt < rst_cnt_num)
//             begin
//                 rst_cnt = rst_cnt + 1'd1;
//             end
//         end
//     end

//     OLED_initial OLED_initial_inst (
//         .clk      (sys_clk),
//         .rst_n    (sys_rst_n),
//         .SPI_BUSY (SPI_BUSY_wire),
//         .en       (OLED_en),

//         .DC           (SPI_DC_wire),
//         .initial_done (),
//         .SPI_en       (SPI_en_wire),
//         .SPI_data     (SPI_data_wire),
//         .data_en      (data_en)
//     );

//     SPI_driver_new SPI_driver_inst (
//         .clk       (sys_clk),
//         .rst_n     (sys_rst_n),
//         .en        (SPI_en_wire),
//         .data_en   (data_en),
//         .user_data (SPI_data_wire),
//         .DC_in     (SPI_DC_wire),

//         .SPI_MOSI (OLED_D1),
//         .SPI_SCK  (OLED_D0),
//         .SPI_DC   (OLED_DC),
//         .SPI_DONE (SPI_BUSY_wire)
//     );
