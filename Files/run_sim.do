vlib work
vlog -f src_files2.list +cover
vlog -f src_files.txt  +cover
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all 

add wave /top/SPIif/*
add wave /top/ramif/*
add wave -position insertpoint  \
sim:/top/SPI_wrapper/RAM/mem
add wave -position insertpoint  \
sim:/top/SPI_wrapper/SLAVE/ns \
sim:/top/SPI_wrapper/SLAVE/cs
add wave /uvm_pkg::uvm_reg_map::do_write/#ublk#215181159#1731/immed__1735 /uvm_pkg::uvm_reg_map::do_read/#ublk#215181159#1771/immed__1775 /SPI_sequence_pkg::SPI_sequence_main::body/#ublk#33843783#43/immed__44 /top/SPI_wrapper/sva_try/check_async_reset /top/SPI_wrapper/sva_try/serial_to_parallel_sva /top/SPI_wrapper/sva_try/parallel_to_serial_sva /top/SPI_wrapper/sva_try/check_ss_n_sva /top/SPI_wrapper/sva_try/miso_check_sva /top/SPI_wrapper/sva_try/pattern1_sva /top/SPI_wrapper/sva_try/pattern2_sva

coverage save SPI_Wrapper_tb.ucdb -onexit -du SPI_Wrapper

#run 0
#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/env_ram/sb/seq_item_sb
#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/env_ram/sb/tx_valid_ref
#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/env_ram/sb/ram_out_ref

#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/env/cov/seq_item_cov


run -all
coverage report -output assertion_coverage.txt -detail -assert 
coverage report -output functional_coverage_rpt.txt -srcfile=* -detail -all -dump -annotate -directive -cvg
#quit -sim
#vcover report SPI_Wrapper_tb.ucdb -details -annotate -all -output code_coverage_rpt.txt
