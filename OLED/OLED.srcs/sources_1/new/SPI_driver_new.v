module SPI_driver_new (
    input       clk,       // 系统时钟
    input       rst_n,     // 复位信号
    input       en,        // 使能信号
    input       data_en,   // 数据使能
    input [7:0] user_data, // 待发送数据
    input       DC_in,

    output SPI_MOSI,       // SPI数据线
    output SPI_SCK,        // SPI时钟线
    output SPI_DC,         // 命令或数据
    output SPI_DONE        // SPI 一帧传送完成信号
    );

    // 状态机编码
    localparam IDLE = 2'd0;
    localparam WAIT = 2'd1;
    localparam READ = 2'd2;
    localparam SEND = 2'd3;

    // 状态寄存器
    reg [1:0] cur_state;
    reg [1:0] nxt_state;

    // 输出 reg 数据
    reg SPI_MOSI_r;
    reg SPI_SCK_r;
    reg SPI_DONE_r;

    reg [7:0] data_send;
    reg [3:0] DATA_cnt;
    reg       SCK_cnt;  // 指示 SCK 的上升沿和下降沿

    // 输出赋值
    assign SPI_MOSI = SPI_MOSI_r;
    assign SPI_SCK  = SPI_SCK_r;
    assign SPI_DC   = DC_in;
    assign SPI_DONE = SPI_DONE_r;

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

    // 根据当前状态，计算次态
    always @(*)
    begin
        nxt_state = cur_state;

        case (cur_state)
            IDLE :
            begin
                // 驱动使能信号生效，进入 WAIT 状态
                if (en)
                begin
                    nxt_state = WAIT;
                end
            end

            WAIT :
            begin
                // 数据使能生效，进入 READ 状态
                if (data_en)
                begin
                    nxt_state = READ;
                end
            end

            READ :
            begin
                // 读取需要传输的数据后，进入 SEND 状态
                nxt_state = SEND;
            end

            SEND :
            begin
                // 一帧数据发送完后，根据使能信号，进入 IDLE 或 WAIT
                if (DATA_cnt == 'd8) // 发完，次态为空闲
                begin
                    if (en)
                    begin
                        nxt_state = WAIT;
                    end
                    else
                    begin
                        nxt_state = IDLE;
                    end
                end
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
            SPI_MOSI_r <= 1'b0;
            SPI_SCK_r  <= 1'b1;
            SPI_DONE_r <= 1'b0;
            DATA_cnt   <= 'd0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    SPI_MOSI_r <= 1'b0;
                    SPI_SCK_r  <= 1'b1;
                    SPI_DONE_r <= 1'b0;
                end

                WAIT :
                begin
                    SPI_MOSI_r <= 1'b0;
                    SPI_SCK_r  <= 1'b1;
                    SPI_DONE_r <= 1'b0;
                end

                READ :
                begin
                    SPI_MOSI_r <= user_data[7];
                    DATA_cnt   <= 'd1;
                    SPI_SCK_r  <= 1'b0;
                    SPI_DONE_r <= 1'b0;
                end

                SEND :
                begin
                    if(SCK_cnt) // 在 SCK 下降沿时，将 data_send 最高位赋给 MOSI
                    begin
                        SPI_MOSI_r <= data_send[7];
                        DATA_cnt   <= DATA_cnt + 'd1;
                    end
                    SPI_SCK_r  <= ~SPI_SCK_r;
                    if (DATA_cnt == 6 && SCK_cnt)
                    begin
                        SPI_DONE_r <= 1'b1;
                    end
                    else
                    begin
                        SPI_DONE_r <= 1'b0;
                    end
                end
            endcase
        end
    end

    // 控制需要传输的数据
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            data_send <= 8'b0000_0000;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    data_send <= 8'b0000_0000;
                end

                WAIT :
                begin
                    data_send <= 8'b0000_0000;
                end

                READ :
                begin
                    data_send <= user_data;
                end

                SEND :
                begin
                    if (!SCK_cnt)
                    begin
                        data_send <= data_send << 1; // 在 SCK 上升沿时，左移
                    end
                end

                default:
                begin
                    data_send <= 8'b0000_0000;
                end
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

                READ :
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
