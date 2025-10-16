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
    input sys_clk,   // 系统时钟
    input sys_rst_n, // 系统复位

    output OLED_D0,  // ?SPI SCK
    output OLED_D1,  // SPI 数据
    output OLED_RST, // OLED 复位，低电平有效
    output OLED_DC   // 1 ：数据 0：命令
   );

    // 状态机编码
    localparam RESET   = 3'd0;
    localparam INITIAL = 3'd1;
    localparam CLEAR   = 3'd2;
    localparam DISPLAY = 3'd3;
    localparam IDLE    = 3'd4;

    // 复位计数
    localparam rst_cnt_num = 'd5_000_000; //5_000_000

    reg [23:0] rst_cnt; // 复位计数器

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

    // initial 模块连线
    wire       initial_DC_wire;
    wire       initial_done_wire;
    wire       initial_SPI_en_wire;
    wire [7:0] initial_SPI_data_wire;
    wire       initial_data_en_wire;
    
    reg        initial_en_wire;

    // SPI 模块连线
    reg       SPI_en_wire;
    reg       SPI_data_en_wire;
    reg [7:0] SPI_user_data_wire;
    reg       SPI_DC_in_wire;

    wire SPI_MOSI_wire;
    wire SPI_SCK_wire;
    wire SPI_DC_wire;
    wire SPI_DONE_wire;

    // clear 模块连线
    reg clear_en_wire;

    wire       clear_DC_wire;
    wire       clear_done_wire;
    wire [7:0] clear_SPI_data_wire;
    wire       clear_data_en_wire;
    wire       clear_SPI_en_wire;

    // display 模块连线
    reg display_en_wire;

    wire       display_DC_wire;
    wire [7:0] display_SPI_data_wire;
    wire       display_data_en_wire;
    wire       display_SPI_en_wire;
    wire       display_done_wire;

    // ===========================================================
    
    //  模块实例化

    // OLED 模块实例化
    OLED_initial OLED_initial_inst (
        .clk      (sys_clk),
        .rst_n    (sys_rst_n),
        .SPI_BUSY (SPI_DONE_wire),
        .en       (initial_en_wire),

        .DC           (initial_DC_wire),
        .initial_done (initial_done_wire),
        .SPI_en       (initial_SPI_en_wire),
        .SPI_data     (initial_SPI_data_wire),
        .data_en      (initial_data_en_wire)
    );

    // SPI 模块实例化
    SPI_driver_new SPI_driver_new_inst (
        .clk       (sys_clk),
        .rst_n     (sys_rst_n),
        .en        (SPI_en_wire),
        .data_en   (SPI_data_en_wire),
        .user_data (SPI_user_data_wire),
        .DC_in     (SPI_DC_in_wire),

        .SPI_MOSI (SPI_MOSI_wire),
        .SPI_SCK  (SPI_SCK_wire),
        .SPI_DC   (SPI_DC_wire),
        .SPI_DONE (SPI_DONE_wire)
    );

    // clear 模块实例化
    OLED_clear OLED_clear_inst (
        .clk      (sys_clk),
        .rst_n    (sys_rst_n),
        .clear_en (clear_en_wire),
        .SPI_done (SPI_DONE_wire), 

        .DC         (clear_DC_wire),
        .clear_done (clear_done_wire),
        .SPI_data   (clear_SPI_data_wire),
        .data_en    (clear_data_en_wire),
        .SPI_en     (clear_SPI_en_wire)
    );

    // display 模块实例化
    OLED_display OLED_display_inst (
            .clk          (sys_clk),
            .rst_n        (sys_rst_n),
            .display_en   (display_en_wire),
            .SPI_done     (SPI_DONE_wire),

            .DC           (display_DC_wire),
            .SPI_data     (display_SPI_data_wire),
            .data_en      (display_data_en_wire),
            .SPI_en       (display_SPI_en_wire),
            .display_done (display_done_wire)
    );

    // ===========================================================

    // 状态机设计

    // 状态迁移
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

    // next state logic
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

    // output logic
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

    // 复位计数
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
