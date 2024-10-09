################## Close Previous Simulation #####################
quit -sim 

############################# AESGenV TB ######################################
    #vlog -work work {../testbench/SystemVerilog Environment/transaction.sv}
    #vlog -work work {../testbench/SystemVerilog Environment/generator.sv}
    #vlog -work work {../testbench/SystemVerilog Environment/driver.sv}
    vlog -work work {../testbench/SystemVerilog Environment/environment.sv}
    vlog -work work {../testbench/SystemVerilog Environment/random_test.sv}
    vlog -work work {../testbench/SystemVerilog Environment/testbench.sv}

####################### Run Simulation #######################
    vsim -sv_seed random -voptargs=+acc work.tbench_top
    do {AES_waveform.do}

run -all