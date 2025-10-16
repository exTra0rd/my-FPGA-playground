-makelib xcelium_lib/xpm -sv \
  "E:/Tools/vivado2020_1/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "E:/Tools/vivado2020_1/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../OLED.srcs/sources_1/ip/rom_picture/sim/rom_picture.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

