// 改进目标：
// 1. 优化复位逻辑，确保各模块在上电后稳定工作
// 2. 优化 SPI 时序，确保数据传输的可靠性

module AD4630 (
    input       clk,
    input [3:0] SDO_0to3,
    input [3:0] SDO_4to7,
	input       AD4630_BUSY,

    output      SPI_SCK,
    output      SPI_MOSI,
    output      AD4630_RESET_N,
    output      AD4630_CS_N,
    output      AD4630_CNV
);

    wire        SPI_BUSY_wire;
    wire        SPI_EN_wire;
    wire [23:0] SPI_DATA_wire;
    wire        SPI_DONE_wire;
    wire        wr_rd_ctrl_wire;

	wire [23:0] AD_DATA_D;
    wire [23:0] AD_DATA_S;
	
	reg rst_n = 1'b0;
	
	reg [5:0] rst_cnt = 6'd0;
	
	always @(posedge clk)
	begin
		if (rst_cnt < 6'd50)
		begin
			rst_n   <= 1'b0;
			rst_cnt <= rst_cnt + 6'd1;
		end
		else
		begin
			rst_n   <= 1'b1;
			rst_cnt <= rst_cnt;
		end
	end

    AD4630_driver AD4630_driver_inst (
        .clk            (clk),
        .rst_n          (rst_n),
        .start_config   (1'b1),
        .SPI_BUSY       (SPI_BUSY_wire),
        .SPI_DONE       (SPI_DONE_wire),
        .AD4630_BUSY    (AD4630_BUSY),

        .SPI_EN         (SPI_EN_wire),
        .SPI_DATA       (SPI_DATA_wire),
        .AD4630_RESET_N (AD4630_RESET_N),
        .wr_rd_ctrl     (wr_rd_ctrl_wire),
        .AD4630_CS_N    (AD4630_CS_N),
        .AD4630_CNV     (AD4630_CNV)
    );

    SPI_driver SPI_driver_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .en         (SPI_EN_wire),
        .data_in    (SPI_DATA_wire),
        .wr_rd_ctrl (wr_rd_ctrl_wire),
        .SDO_0to3   (SDO_0to3),
        .SDO_4to7   (SDO_4to7),

        .SPI_SCK    (SPI_SCK),
        .SPI_MOSI   (SPI_MOSI),
        .SPI_BUSY   (SPI_BUSY_wire),
        .SPI_DONE   (SPI_DONE_wire),
        .AD_DATA_D  (AD_DATA_D),
        .AD_DATA_S  (AD_DATA_S)
    );

endmodule