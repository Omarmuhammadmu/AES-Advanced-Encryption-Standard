################## Close Previous Simulation #####################
quit -sim 

####################### AES Packages ##########################
    vlog -work work {../rtl/aes_package.sv}

####################### AES interface ##########################
    vlog -work work {../rtl/aes_interface.sv}

####################### AES Cipher ##########################
    vlog -work work {../rtl/cipher/sbox.sv}
    vlog -work work {../rtl/cipher/round.sv}
    vlog -work work {../rtl/cipher/aes_cipher.sv}

####################### AES Decipher ##########################
    vlog -work work {../rtl/decipher/inverse_sbox.sv}
    vlog -work work {../rtl/decipher/inverse_round.sv}
    vlog -work work {../rtl/decipher/aes_decipher.sv}

####################### AES key expansion ##########################
    vlog -work work {../rtl/key expansion/g_operator.sv}
    vlog -work work {../rtl/key expansion/key_expansion.sv}

############################# AES Top ######################################
    vlog -work work {../rtl/aes.sv}

####################### Run Simulation #######################
    #do {simple_test_do/TestBench_run.do}
    do {sv_env_do/TestBench_run.do}