vlib work
vlog -f spi_files.txt +cover
vsim -voptargs=+acc work.top_uvm -classdebug -uvmcontrol=all -cover
add wave /top_uvm/gold_if/*
add wave /top_uvm/spi_if/*
coverage save spi.ucdb -onexit
run -all