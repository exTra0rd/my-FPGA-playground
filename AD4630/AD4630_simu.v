module AD4630_simu (
    input CNV,
    input clk,
    input rst_n,

    output AD4630_BUSY
);

    reg AD4630_BUSY_r;
    assign AD4630_BUSY = AD4630_BUSY_r;

    localparam BUSY_TIME = 14;

    localparam IDLE = 1'b0,
               BUSY = 1'b1;

    reg cur_state;
    reg nxt_state;

    reg [3:0] cnt;

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

    always @(*)
    begin
        nxt_state = cur_state; // 防止锁存器产生

        case (cur_state)
            IDLE :
            begin
                if (CNV)
                begin
                    nxt_state = BUSY;
                end
            end

            BUSY :
            begin
                if (cnt >= BUSY_TIME)
                begin
                    nxt_state = IDLE;
                end
            end

            default :
            begin
                nxt_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            AD4630_BUSY_r <= 1'b0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    if (CNV)
                    begin
                        AD4630_BUSY_r <= 1'b1;
                    end
                    else
                    begin
                        AD4630_BUSY_r <= 1'b0;
                    end
                end

                BUSY :
                begin
                    AD4630_BUSY_r <= 1'b1;
                end

                default :
                begin
                    AD4630_BUSY_r <= 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            cnt <= 4'd0;
        end
        else
        begin
            case (cur_state)
                IDLE :
                begin
                    cnt <= 4'd0;
                end

                BUSY :
                begin
                    cnt <= cnt + 4'd1;
                end

                default :
                begin
                    cnt <= 4'd0;
                end
            endcase
        end
    end

endmodule