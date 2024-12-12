quit -sim

file delete -force work

vlib work

vlog *.sv

vsim fifo_priority_tb

do wave.do

run -all