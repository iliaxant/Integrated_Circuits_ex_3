onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_priority_tb/rst
add wave -noupdate /fifo_priority_tb/clk
add wave -noupdate -expand -group FIFO_IN -radix hexadecimal /fifo_priority_tb/data_in
add wave -noupdate -expand -group FIFO_IN /fifo_priority_tb/vld_i
add wave -noupdate -expand -group FIFO_IN /fifo_priority_tb/rdy_o
add wave -noupdate -expand -group FIFO_OUT -radix hexadecimal /fifo_priority_tb/data_out
add wave -noupdate -expand -group FIFO_OUT /fifo_priority_tb/vld_o
add wave -noupdate -expand -group FIFO_OUT /fifo_priority_tb/rdy_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {699 ps}
