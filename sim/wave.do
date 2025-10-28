onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut0/out_chan
add wave -noupdate /top/dut0/out_data0
add wave -noupdate /top/dut0/out_data1
add wave -noupdate /top/dut0/out_data2
add wave -noupdate /top/dut0/out_data3
add wave -noupdate /top/dut0/head
add wave -noupdate /top/dut0/tail
add wave -noupdate /top/dut0/q_full
add wave -noupdate /top/dut0/head_data
add wave -noupdate /top/dut0/head_chan
add wave -noupdate /top/dut0/sel_data
add wave -noupdate /top/dut0/st
add wave -noupdate /top/dut0/next_st
add wave -noupdate /top/dut0/cnt
add wave -noupdate /top/dut0/valid
add wave -noupdate /top/dut0/fire_a3
add wave -noupdate /top/mux_in_if0/req
add wave -noupdate /top/mux_in_if0/chan
add wave -noupdate /top/mux_in_if0/in_data
add wave -noupdate /top/mux_in_if0/q_full
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {745 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1471 ns}
