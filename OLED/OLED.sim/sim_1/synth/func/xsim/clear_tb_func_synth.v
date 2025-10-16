// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Sep 16 14:55:00 2025
// Host        : DESKTOP-A8M6AM2 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               E:/Projects/Kintex7_Project/OLED/OLED.sim/sim_1/synth/func/xsim/clear_tb_func_synth.v
// Design      : OLED_initial
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* Display_off = "8'b10101110" *) (* Display_on = "8'b10101111" *) (* S0 = "5'b00000" *) 
(* S1 = "5'b00001" *) (* S10 = "5'b01010" *) (* S11 = "5'b01011" *) 
(* S2 = "5'b00010" *) (* S3 = "5'b00011" *) (* S4 = "5'b00100" *) 
(* S5 = "5'b00101" *) (* S6 = "5'b00110" *) (* S7 = "5'b00111" *) 
(* S8 = "5'b01000" *) (* S9 = "5'b01001" *) (* Set_charge_pump_0 = "8'b10001101" *) 
(* Set_charge_pump_1 = "8'b00010100" *) (* Set_contrast_0 = "8'b10000001" *) (* Set_contrast_1 = "8'b11001111" *) 
(* Set_display_clk_0 = "8'b11010101" *) (* Set_display_clk_1 = "8'b10000000" *) (* Set_inverse = "8'b10100111" *) 
(* Set_normal = "8'b10100110" *) (* Set_precharge_0 = "8'b11011001" *) (* Set_precharge_1 = "8'b11110001" *) 
(* NotValidForBitStream *)
module OLED_initial
   (clk,
    rst_n,
    SPI_done,
    DC,
    initial_done,
    SPI_send,
    SPI_data);
  input clk;
  input rst_n;
  input SPI_done;
  output DC;
  output initial_done;
  output SPI_send;
  output [7:0]SPI_data;

  wire DC;
  wire \FSM_onehot_cur_state[11]_i_1_n_0 ;
  wire \FSM_onehot_cur_state[11]_i_2_n_0 ;
  wire \FSM_onehot_cur_state_reg_n_0_[0] ;
  wire \FSM_onehot_cur_state_reg_n_0_[10] ;
  wire \FSM_onehot_cur_state_reg_n_0_[1] ;
  wire \FSM_onehot_cur_state_reg_n_0_[2] ;
  wire \FSM_onehot_cur_state_reg_n_0_[3] ;
  wire \FSM_onehot_cur_state_reg_n_0_[4] ;
  wire \FSM_onehot_cur_state_reg_n_0_[5] ;
  wire \FSM_onehot_cur_state_reg_n_0_[6] ;
  wire \FSM_onehot_cur_state_reg_n_0_[7] ;
  wire \FSM_onehot_cur_state_reg_n_0_[8] ;
  wire \FSM_onehot_cur_state_reg_n_0_[9] ;
  wire [7:0]SPI_data;
  wire [7:0]SPI_data_OBUF;
  wire \SPI_data_OBUF[7]_inst_i_2_n_0 ;
  wire \SPI_data_OBUF[7]_inst_i_3_n_0 ;
  wire SPI_done;
  wire SPI_done_IBUF;
  wire SPI_send;
  wire SPI_send_OBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire initial_done;
  wire initial_done_OBUF;
  wire rst_n;
  wire rst_n_IBUF;

  OBUF DC_OBUF_inst
       (.I(1'b0),
        .O(DC));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_onehot_cur_state[11]_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[10] ),
        .I1(initial_done_OBUF),
        .O(\FSM_onehot_cur_state[11]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_onehot_cur_state[11]_i_2 
       (.I0(rst_n_IBUF),
        .O(\FSM_onehot_cur_state[11]_i_2_n_0 ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDPE #(
    .INIT(1'b1)) 
    \FSM_onehot_cur_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .D(1'b0),
        .PRE(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[0] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[9] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[10] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state[11]_i_1_n_0 ),
        .Q(initial_done_OBUF));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[0] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[1] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[1] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[2] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[2] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[3] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[3] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[4] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[4] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[5] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[5] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[6] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[7] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[7] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[8] ));
  (* FSM_ENCODED_STATES = "S0:000000000001,S9:001000000000,S7:000010000000,S8:000100000000,S6:000001000000,S5:000000100000,S3:000000001000,S4:000000010000,S2:000000000100,S11:100000000000,S10:010000000000,S1:000000000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_cur_state_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(SPI_done_IBUF),
        .CLR(\FSM_onehot_cur_state[11]_i_2_n_0 ),
        .D(\FSM_onehot_cur_state_reg_n_0_[8] ),
        .Q(\FSM_onehot_cur_state_reg_n_0_[9] ));
  OBUF \SPI_data_OBUF[0]_inst 
       (.I(SPI_data_OBUF[0]),
        .O(SPI_data[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \SPI_data_OBUF[0]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[5] ),
        .I1(\SPI_data_OBUF[7]_inst_i_3_n_0 ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[9] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[10] ),
        .I4(\FSM_onehot_cur_state_reg_n_0_[3] ),
        .I5(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .O(SPI_data_OBUF[0]));
  OBUF \SPI_data_OBUF[1]_inst 
       (.I(SPI_data_OBUF[1]),
        .O(SPI_data[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \SPI_data_OBUF[1]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[0] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[9] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[10] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .O(SPI_data_OBUF[1]));
  OBUF \SPI_data_OBUF[2]_inst 
       (.I(SPI_data_OBUF[2]),
        .O(SPI_data[2]));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \SPI_data_OBUF[2]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[1] ),
        .I1(\SPI_data_OBUF[7]_inst_i_2_n_0 ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[3] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .I4(\FSM_onehot_cur_state_reg_n_0_[4] ),
        .O(SPI_data_OBUF[2]));
  OBUF \SPI_data_OBUF[3]_inst 
       (.I(SPI_data_OBUF[3]),
        .O(SPI_data[3]));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \SPI_data_OBUF[3]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[3] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[0] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[10] ),
        .I4(\FSM_onehot_cur_state_reg_n_0_[7] ),
        .O(SPI_data_OBUF[3]));
  OBUF \SPI_data_OBUF[4]_inst 
       (.I(SPI_data_OBUF[4]),
        .O(SPI_data[4]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \SPI_data_OBUF[4]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[7] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[8] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[4] ),
        .O(SPI_data_OBUF[4]));
  OBUF \SPI_data_OBUF[5]_inst 
       (.I(SPI_data_OBUF[5]),
        .O(SPI_data[5]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \SPI_data_OBUF[5]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[0] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[9] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[10] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[8] ),
        .O(SPI_data_OBUF[5]));
  OBUF \SPI_data_OBUF[6]_inst 
       (.I(SPI_data_OBUF[6]),
        .O(SPI_data[6]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \SPI_data_OBUF[6]_inst_i_1 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[7] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[8] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .O(SPI_data_OBUF[6]));
  OBUF \SPI_data_OBUF[7]_inst 
       (.I(SPI_data_OBUF[7]),
        .O(SPI_data[7]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \SPI_data_OBUF[7]_inst_i_1 
       (.I0(\SPI_data_OBUF[7]_inst_i_2_n_0 ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[5] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[6] ),
        .I3(\FSM_onehot_cur_state_reg_n_0_[3] ),
        .I4(\FSM_onehot_cur_state_reg_n_0_[2] ),
        .I5(\SPI_data_OBUF[7]_inst_i_3_n_0 ),
        .O(SPI_data_OBUF[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \SPI_data_OBUF[7]_inst_i_2 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[10] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[9] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[0] ),
        .O(\SPI_data_OBUF[7]_inst_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \SPI_data_OBUF[7]_inst_i_3 
       (.I0(\FSM_onehot_cur_state_reg_n_0_[8] ),
        .I1(\FSM_onehot_cur_state_reg_n_0_[7] ),
        .I2(\FSM_onehot_cur_state_reg_n_0_[1] ),
        .O(\SPI_data_OBUF[7]_inst_i_3_n_0 ));
  IBUF SPI_done_IBUF_inst
       (.I(SPI_done),
        .O(SPI_done_IBUF));
  OBUF SPI_send_OBUF_inst
       (.I(SPI_send_OBUF),
        .O(SPI_send));
  LUT1 #(
    .INIT(2'h1)) 
    SPI_send_OBUF_inst_i_1
       (.I0(initial_done_OBUF),
        .O(SPI_send_OBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF initial_done_OBUF_inst
       (.I(initial_done_OBUF),
        .O(initial_done));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
