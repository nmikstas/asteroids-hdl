onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label {6 MHz Clock} /tb_vec_gen_top/clk6mhz
add wave -noupdate -label {3 MHz Clock} /tb_vec_gen_top/clk3mhz
add wave -noupdate -label {CPU Clock} /tb_vec_gen_top/vgck
add wave -noupdate -label {Reset N} /tb_vec_gen_top/reset_n
add wave -noupdate -label {DMA Go N} /tb_vec_gen_top/dmago_n
add wave -noupdate -label {CPU Read/Write} /tb_vec_gen_top/r_wb
add wave -noupdate -label {CPU Address Bus} -radix hexadecimal /tb_vec_gen_top/ab
add wave -noupdate -label {CPU Data Bus} /tb_vec_gen_top/db
add wave -noupdate -label {Vector Generator Halt} /tb_vec_gen_top/halt
add wave -noupdate -label {Beam Blank N} /tb_vec_gen_top/blank_n
add wave -noupdate -label {State Machine address} -radix hexadecimal /tb_vec_gen_top/vec_gen_top_0/vec_state_machine_0/adr
add wave -noupdate -label {DAC Output X} -radix unsigned /tb_vec_gen_top/dacx_s
add wave -noupdate -label {DAC Output Y} -radix unsigned /tb_vec_gen_top/dacy_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {114803045 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 154
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {333023710 ps}
