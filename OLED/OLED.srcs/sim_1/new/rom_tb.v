`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 15:40:50
// Design Name: 
// Module Name: rom_tb
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


module rom_tb ();

    reg       clk;

    wire [10:0] addra;
    wire [7:0]  douta;

    reg clk_data;

    reg [7:0] x_temp;
    reg [7:0] y_temp;

    rom_picture rom_picture_inst (
        .clka  (clk),
        .addra (addra),
        .douta (douta)
    );

    initial
    begin
        clk      = 0;
        clk_data = 0;
        x_temp   = 'd37;
        y_temp   = 'd1;
    end

    always
    begin
        #5 clk = ~clk;
    end

    always
    begin
        #50 clk_data = ~clk_data;
    end

    always @(posedge clk_data)
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

    assign addra = {3'b000, y_temp} * 11'd128 + {3'b000, x_temp};

endmodule
