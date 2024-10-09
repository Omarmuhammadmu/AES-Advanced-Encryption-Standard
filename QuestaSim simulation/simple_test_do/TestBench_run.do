# Close Previous Simulation
quit -sim 

############################# AESGenV TB ######################################
    vlog -work work {../testbench/Simple_testbench/aes_tb.sv}

####################### Run Simulation #######################
    vsim -sv_seed 3735598629 -voptargs=+acc work.aes_tb
    do {AES_waveform.do}

run -all