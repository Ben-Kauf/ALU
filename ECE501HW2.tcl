transcript off

quit -sim

cd {C:\intelFPGA_projects\ECE501HW2}
vlib work
vmap work work

vcom +acc ECE501HW2.vhd
vcom +acc test_ECE501HW2.vhd

vsim test_ECE501HW2
add wave sim:/test_ECE501HW2/dev_to_test/*

run 10000 s

wave zoom full