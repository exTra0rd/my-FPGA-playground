module SPI_driver (
    input         en,         // 使能信号
    input         clk,        // 时钟
    input         rst_n,      // 复位
    input [23:0]  data_in,    // 输入数据
    input         wr_rd_ctrl, // SPI 接口读写控制，1：读，0：写
    input [3:0]   SDO_0to3,   // AD4630 SDO 0 - 3 通道
    input [3:0]   SDO_4to7,   // AD4630 SDO 4 - 7 通道

    output        SPI_SCK,    // SPI 时钟输出
    output        SPI_MOSI,   // SPI 主机 -> 从机
    output [23:0] AD_DATA_D,  // AD4630 数据输出（驱动模态）
    output [23:0] AD_DATA_S,  // AD4630 数据输出（检测模态）
    output        SPI_BUSY,   // SPI 忙碌信号
    output        SPI_DONE    // SPI 完成信号
);

    /*                             参数定义                             */

    localparam WRITE_WIDTH = 5'd24; // 写入数据位宽
    localparam READ_DEPTH  = 5'd6;  // 读取数据深度

    // 状态机编码
    localparam IDLE  = 4'b0001,
               READ  = 4'b0010,
               WRITE = 4'b0100,
               DONE  = 4'b1000;

    localparam STATE_MACHINE_WIDTH = 4; // 状态机编码宽度

    //-----------------------------------------------------------------//

    /*                             输出信号赋值                             */

    reg        SPI_SCK_r;   // SPI 时钟输出
    reg        SPI_SCK_1d;  // SCK 打一拍
    reg        SPI_MOSI_r;  // SPI 主机 -> 从机
    reg [23:0] AD_DATA_D_r; // AD4630 数据输出（驱动模态）
    reg [23:0] AD_DATA_S_r; // AD4630 数据输出（检测模态）
    reg        SPI_BUSY_r;  // SPI 忙碌信号
    reg        SPI_DONE_r;  // SPI 完成信号

    assign SPI_SCK   = SPI_SCK_1d;
    assign SPI_MOSI  = SPI_MOSI_r;
    assign AD_DATA_D = AD_DATA_D_r;
    assign AD_DATA_S = AD_DATA_S_r;
    assign SPI_BUSY  = SPI_BUSY_r;
    assign SPI_DONE  = SPI_DONE_r;

    //--------------------------------------------------------------------//

    /*                             reg 数据定义                             */

    reg [23:0] data_in_latch; // 待写入数据锁存

    reg       edge_cnt; // 用于指示 SCK 的边沿
    reg [4:0] SCK_cnt;

    reg [23:0] AD_DATA_D_shift; // AD4630 驱动模态数据移位寄存器
    reg [23:0] AD_DATA_S_shift; // AD4630 检测模态数据移位寄存器

    //---------------------------------------------------------------------//

    /*                             三段式状态机                             */

    reg [STATE_MACHINE_WIDTH - 1:0] cur_state;
    reg [STATE_MACHINE_WIDTH - 1:0] nxt_state;

    // 第一段：状态转移
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

    // 第二段：计算次态
    always @(*)
    begin
        nxt_state = cur_state; // 防止锁存器产生

        case (cur_state)
            IDLE :
            begin
                if (en)
                begin
                    nxt_state = wr_rd_ctrl ? READ : WRITE;
                end
            end

            READ :
            begin
                // 写入完毕后，进入 DONE 状态
                if (SCK_cnt == READ_DEPTH && edge_cnt)
                begin
                    nxt_state = DONE;
                end
            end

            WRITE :
            begin
                // 写入完毕后，进入 DONE 状态
                if (SCK_cnt == WRITE_WIDTH - 1 && edge_cnt)
                begin
                    nxt_state = DONE;
                end
            end

            DONE :
            begin
                nxt_state = IDLE;
            end

            default :
            begin
                nxt_state = IDLE;
            end
        endcase
    end

    // 第三段：输出逻辑
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            SPI_SCK_r   <= 1'b0;
            SPI_MOSI_r  <= 1'b0;
            AD_DATA_D_r <= 24'd0;
            AD_DATA_S_r <= 24'd0;
            SPI_BUSY_r  <= 1'b0;
            SPI_DONE_r  <= 1'b0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    SPI_SCK_r   <= 1'b0;
                    SPI_MOSI_r  <= 1'b0;
                    AD_DATA_D_r <= AD_DATA_D_r;
                    AD_DATA_S_r <= AD_DATA_S_r;
                    SPI_BUSY_r  <= 1'b0;
                    SPI_DONE_r  <= 1'b0;
                end

                READ :
                begin
                    SPI_SCK_r   <= ~SPI_SCK_r;
                    SPI_MOSI_r  <= 1'b0;
                    if (SCK_cnt == READ_DEPTH)
                    begin
                        AD_DATA_D_r <= {AD_DATA_D_shift[19:0], SDO_0to3};
                        AD_DATA_S_r <= {AD_DATA_S_shift[19:0], SDO_4to7};
                    end
                    SPI_BUSY_r  <= 1'b1;
                    SPI_DONE_r  <= 1'b0;
                end

                WRITE :
                begin
                    SPI_SCK_r   <= ~SPI_SCK_r;
                    SPI_MOSI_r  <= data_in_latch[WRITE_WIDTH - 1];
                    AD_DATA_D_r <= AD_DATA_D_r;
                    AD_DATA_S_r <= AD_DATA_S_r;
                    SPI_BUSY_r  <= 1'b1;
                    SPI_DONE_r  <= 1'b0;
                end

                DONE :
                begin
                    SPI_SCK_r   <= 1'b0;
                    SPI_MOSI_r  <= 1'b0;
                    AD_DATA_D_r <= AD_DATA_D_r;
                    AD_DATA_S_r <= AD_DATA_S_r;
                    SPI_BUSY_r  <= 1'b0;
                    SPI_DONE_r  <= 1'b1;
                end

                default :
                begin
                    SPI_SCK_r   <= 1'b0;
                    SPI_MOSI_r  <= 1'b0;
                    AD_DATA_D_r <= AD_DATA_D_r;
                    AD_DATA_S_r <= AD_DATA_S_r;
                    SPI_BUSY_r  <= 1'b0;
                    SPI_DONE_r  <= 1'b0;
                end
            endcase
        end
    end

    //--------------------------------------------------------------------//

    /*                             数据控制                             */

    // data_in_latch 移位控制 / AD_DATA_D_shift 和 AD_DATA_S_shift 移位控制
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            data_in_latch   <= 'd0;
            SCK_cnt         <= 'd0;
            AD_DATA_D_shift <= 24'd0;
            AD_DATA_S_shift <= 24'd0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    if (en && !wr_rd_ctrl)
                    begin
                        data_in_latch <= data_in;
                    end
                    else
                    begin
                        data_in_latch <= 'd0;
                    end
                end

                WRITE :
                begin
                    if (edge_cnt) // 在 SCK 下降沿时移位
                    begin
                        data_in_latch <= {data_in_latch[WRITE_WIDTH-2:0], 1'b0};
                        SCK_cnt       <= SCK_cnt + 1'b1;
                    end
                end

                READ :
                begin
                    if (!edge_cnt) // 在 SCK 上升沿时读取数据
                    begin
                        AD_DATA_D_shift <= {AD_DATA_D_shift[19:0], SDO_0to3};
                        AD_DATA_S_shift <= {AD_DATA_S_shift[19:0], SDO_4to7};
                        SCK_cnt         <= SCK_cnt + 1'b1;
                    end
                end

                default :
                begin
                    data_in_latch   <= data_in_latch;
                    AD_DATA_D_shift <= AD_DATA_D_shift;
                    AD_DATA_S_shift <= AD_DATA_S_shift;
                    SCK_cnt         <= 'd0;
                end
            endcase
        end
    end

    // SCK 边沿指示
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            edge_cnt <= 'd0;
        end
        else
        begin
            if ((cur_state == WRITE) || (cur_state == READ)) // 在 READ 或 WRITE 状态下计数
            begin
                edge_cnt <= edge_cnt + 1'b1;
            end
            else
            begin
                edge_cnt <= 'd0;
            end
        end
    end

    // SCK 打一拍
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            SPI_SCK_1d <= 1'b0;
        end
        else
        begin
            SPI_SCK_1d <= SPI_SCK_r;
        end
    end

    //--------------------------------------------------------------------//


endmodule