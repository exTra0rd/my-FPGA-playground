# 创建时钟约束，周期为20ns（对应频率50MHz），时钟名称为clk，关联到clk端口
create_clock -period 20.000 -name clk [get_ports sys_clk]

# 设置SPI配置总线宽度为4位
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

# 配置模式为SPIx4（4线SPI模式）
set_property CONFIG_MODE SPIx4 [current_design]

# 配置速率为50MHz
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

# 启用比特流压缩
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# 未使用的引脚设置为上拉
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]

# 配置块电压源为VCCO
set_property CFGBVS VCCO [current_design]

# 配置电压为3.3V
set_property CONFIG_VOLTAGE 3.3 [current_design]


# 时钟信号使用LVCMOS33标准，位于G22引脚
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN G22 [get_ports sys_clk]

# 复位信号（低电平有效）使用LVCMOS33标准，位于D26引脚
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]
set_property PACKAGE_PIN D26 [get_ports sys_rst_n]


# OLED复位引脚，使用LVCMOS33标准，位于J21引脚
set_property IOSTANDARD LVCMOS33 [get_ports OLED_RST]
set_property PACKAGE_PIN J21 [get_ports OLED_RST]

# OLED数据/命令选择引脚，使用LVCMOS33标准，位于H22引脚
set_property IOSTANDARD LVCMOS33 [get_ports OLED_DC]
set_property PACKAGE_PIN H22 [get_ports OLED_DC]

# OLED时钟引脚，使用LVCMOS33标准，位于J24引脚
set_property IOSTANDARD LVCMOS33 [get_ports OLED_D0]
set_property PACKAGE_PIN J24 [get_ports OLED_D0]

# OLED数据引脚，使用LVCMOS33标准，位于J25引脚
set_property IOSTANDARD LVCMOS33 [get_ports OLED_D1]
set_property PACKAGE_PIN J25 [get_ports OLED_D1]