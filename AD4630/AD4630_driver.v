module AD4630_driver (
    input         clk,
    input         rst_n,
    input         start_config,
    input         SPI_BUSY,
    input         SPI_DONE,
    input         AD4630_BUSY,

    output        SPI_EN,
    output [23:0] SPI_DATA,
    output        AD4630_RESET_N,
    output        wr_rd_ctrl,
    output        AD4630_CS_N,
    output        AD4630_CNV
);
    /*                             参数定义                             */
    
    // AD4630 驱动状态机编码
    localparam IDLE        = 10'b00_0000_0001, // 空闲状态
               RESET       = 10'b00_0000_0010, // 复位状态
               ENTR_CONFIG = 10'b00_0000_0100, // 进入配置状态
               DO_CONFIG   = 10'b00_0000_1000, // 执行配置状态
               EXIT_CONFIG = 10'b00_0001_0000, // 退出配置状态
               WAIT_FIRST  = 10'b00_0010_0000, // 等待第一次转换状态
               FIRST_CNV   = 10'b00_0100_0000, // 第一次转换状态
               WAIT_CNV    = 10'b00_1000_0000, // 等待转换状态
               READ_DATA   = 10'b01_0000_0000, // 读取 AD4630 数据
               TRANS_DATA  = 10'b10_0000_0000; // 传输数据状态

    localparam STATE_MACHINE_WIDTH = 10; // 状态机编码宽度

    localparam RESET_DELAY = 300_000, // 复位延时，单位：时钟周期（20 ns），至少3 ms（此处为 6 ms）
               RESET_PW    = 300_005, // 复位脉宽，单位：时钟周期（20 ns），至少50 ns（此处为 100 ns）
               RESET_END   = 340_005; // 复位等待时间，单位：时钟周期（20 ns），至少750 us（此处为 800 us）

    // AD4630 驱动寄存器指令
    localparam REGISTER_MODES_CODE = 24'h00_2084,
               ENTR_CONFIG_CODE    = 24'hBF_FFFF,
               EXIT_CONFIG_CODE    = 24'h00_1401;

    // CNV 信号控制参数
    localparam CNVH_START = 1,
               CNVH_END   = 6,
               CNVT       = 25;

    //-----------------------------------------------------------------//
               
    reg [STATE_MACHINE_WIDTH - 1:0] cur_state;
    reg [STATE_MACHINE_WIDTH - 1:0] nxt_state;

    // 输出 reg
    reg        SPI_EN_r;
    reg [23:0] SPI_DATA_r;
    reg        AD4630_RESET_N_r;
    reg        wr_rd_ctrl_r;
    reg        AD4630_CS_N_r;
    reg        AD4630_CNV_r;

    assign SPI_EN         = SPI_EN_r;
    assign SPI_DATA       = SPI_DATA_r;
    assign AD4630_RESET_N = AD4630_RESET_N_r;
    assign wr_rd_ctrl     = wr_rd_ctrl_r;
    assign AD4630_CS_N    = AD4630_CS_N_r;
    assign AD4630_CNV     = AD4630_CNV_r;

    // reg 类型中间数据
    reg [18:0] reset_cnt; // 复位计数器

    /*                             三段式状态机                             */

    // 状态转移
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

    // 组合逻辑，计算下一个状态
    always @(*)
    begin
        nxt_state = cur_state; // 防止锁存器产生

        case (cur_state)
            IDLE :
            begin
                if (start_config)
                begin
                    nxt_state = RESET;
                end
            end

            RESET :
            begin
                // 复位结束，进入配置状态
                if (reset_cnt > RESET_END)
                begin
                    nxt_state = ENTR_CONFIG;
                end
            end

            ENTR_CONFIG :
            begin
                // 如果 SPI_BUSY 由 1 -> 0，进入下一个状态
                if (SPI_DONE)
                begin
                    nxt_state = DO_CONFIG;
                end
            end

            DO_CONFIG :
            begin
                // 如果 SPI_BUSY 由 1 -> 0，进入下一个状态
                if (SPI_DONE)
                begin
                    nxt_state = EXIT_CONFIG;
                end
            end

            EXIT_CONFIG :
            begin
                // 如果 SPI_BUSY 由 1 -> 0，进入下一个状态
                if (SPI_DONE)
                begin
                    nxt_state = WAIT_FIRST;
                end
            end

            WAIT_FIRST :
            begin
                // 如果 AD4630_BUSY 变高，表示转换开始，进入 FIRST_CNV 状态
                if (AD4630_BUSY)
                begin
                    nxt_state = FIRST_CNV;
                end
            end

            FIRST_CNV :
            begin
                // 如果 AD4630_BUSY 拉低，即AD4630 转换完成，进入 READ_DATA
                if (!AD4630_BUSY)
                begin
                    nxt_state = WAIT_CNV;
                end
            end

            WAIT_CNV :
            begin
                // 如果 SPI_DONE，表示数据读取完成，进入 TRANS_DATA 状态
                if (AD4630_BUSY)
                begin
                    nxt_state = READ_DATA;
                end
            end

            READ_DATA :
            begin
                // 如果 SPI_DONE，表示数据
                if (SPI_DONE)
                begin
                    nxt_state = TRANS_DATA;
                end
            end

            TRANS_DATA :
            begin
                nxt_state = WAIT_CNV;
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
            SPI_EN_r         <= 1'b0;
            SPI_DATA_r       <= 24'd0;
            AD4630_RESET_N_r <= 1'b1;
            wr_rd_ctrl_r     <= 1'b0;
            AD4630_CS_N_r    <= 1'b1;
        end
        else
        begin
            case (cur_state)
                RESET :
                begin
                    SPI_EN_r         <= 1'b0;
                    SPI_DATA_r       <= 24'd0;
                    AD4630_RESET_N_r <= (reset_cnt > RESET_DELAY && reset_cnt <= RESET_PW) ? 1'b0 : 1'b1;
                    wr_rd_ctrl_r     <= 1'b0;
                    AD4630_CS_N_r    <= 1'b1;
                end

                ENTR_CONFIG :
                begin
                    SPI_EN_r         <= (!SPI_BUSY && !SPI_DONE) ? 1'b1 : 1'b0;
                    SPI_DATA_r       <= ENTR_CONFIG_CODE;
                    AD4630_RESET_N_r <= 1'b1;
                    wr_rd_ctrl_r     <= 1'b0;
                    AD4630_CS_N_r    <= SPI_DONE ? 1'b1 : 1'b0;
                end

                DO_CONFIG :
                begin
                    SPI_EN_r         <= (!SPI_BUSY && !SPI_DONE) ? 1'b1 : 1'b0;
                    SPI_DATA_r       <= REGISTER_MODES_CODE;
                    AD4630_RESET_N_r <= 1'b1;
                    wr_rd_ctrl_r     <= 1'b0;
                    AD4630_CS_N_r    <= SPI_DONE ? 1'b1 : 1'b0;
                end

                EXIT_CONFIG :
                begin
                    SPI_EN_r         <= (!SPI_BUSY && !SPI_DONE) ? 1'b1 : 1'b0;
                    SPI_DATA_r       <= EXIT_CONFIG_CODE;
                    AD4630_RESET_N_r <= 1'b1;
                    wr_rd_ctrl_r     <= 1'b0;
                    AD4630_CS_N_r    <= SPI_DONE ? 1'b1 : 1'b0;
                end

                READ_DATA :
                begin
                    SPI_EN_r         <= (!SPI_BUSY && !SPI_DONE) ? 1'b1 : 1'b0;
                    SPI_DATA_r       <= 24'd0; // 读取数据，发送全 0
                    AD4630_RESET_N_r <= 1'b1;
                    wr_rd_ctrl_r     <= 1'b1;  // 读操作
                    AD4630_CS_N_r    <= 1'b0;
                end

                default :
                begin
                    SPI_EN_r         <= 1'b0;
                    SPI_DATA_r       <= 24'd0;
                    AD4630_RESET_N_r <= 1'b1;
                    wr_rd_ctrl_r     <= 1'b0;
                    AD4630_CS_N_r    <= 1'b1;
                end
            endcase
        end
    end

    //-----------------------------------------------------------------//

    /*                             CNV 信号生成                             */
    
    reg [4:0] CNV_cnt;

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            AD4630_CNV_r <= 1'b0;
            CNV_cnt      <= 5'd0;
        end
        else
        begin
            if ((cur_state == WAIT_FIRST) ||
                (cur_state == FIRST_CNV)  ||
                (cur_state == WAIT_CNV)   ||
                (cur_state == READ_DATA)  ||
                (cur_state == TRANS_DATA))
            begin
                AD4630_CNV_r <= ((CNV_cnt > CNVH_START) && (CNV_cnt <= CNVH_END)) ? 1'b1 : 1'b0;
                if (CNV_cnt < CNVT - 1)
                begin
                    CNV_cnt <= CNV_cnt + 1'b1;
                end
                else
                begin
                    CNV_cnt <= 5'd0;
                end
            end
            else
            begin
                AD4630_CNV_r <= 1'b0;
                CNV_cnt      <= 5'd0;
            end
        end
    end

    //---------------------------------------------------------------------//

    /*                             复位计数器                             */
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            reset_cnt <= 19'd0;
        end
        else
        begin
            if (cur_state == RESET)
            begin
                reset_cnt <= reset_cnt + 19'd1;
            end
            else
            begin
                reset_cnt <= 19'd0;
            end
        end
    end

    //-----------------------------------------------------------------//

endmodule