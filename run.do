vlib work

vlog RAM_.sv SPI_RAM_.sv interface_design.sv interface_golden.sv config_obj_design.sv sequence_item_.sv sequence_.sv sequencer_.sv driver_.sv monitor_.sv agent_.sv scoreboard_.sv coverage_collector.sv environment.sv test.sv  assertion_ram.sv top.sv   +cover -covercells

vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all

add wave *
run 0
add wave -position insertpoint  \

coverage save RAM_Cover.ucdb -onexit

run -all

