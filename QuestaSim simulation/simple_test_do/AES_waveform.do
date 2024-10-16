onerror {resume}
quietly WaveActivateNextPane {} 0

####################### Global Signals ##########################
add wave -noupdate -height 24 -group {System Global Signals} -radix hexadecimal sim:/aes_tb/rst
add wave -noupdate -height 24 -group {System Global Signals}                    sim:/aes_tb/clk

####################### Key signals ##########################
add wave -noupdate -radix hexadecimal -group {AES Key} /aes_tb/tb_intf/key_encryption

####################### Encryption Signals ##########################
add wave -noupdate -radix binary -group {Encryption signals}        /aes_tb/tb_intf/start_encryption
add wave -noupdate -radix hexadecimal -group {Encryption signals}   /aes_tb/tb_intf/plaintext_encryption
add wave -noupdate -radix hexadecimal -group {Encryption signals}   /aes_tb/tb_intf/cyphertext_encryption
add wave -noupdate -radix binary -group {Encryption signals}        /aes_tb/tb_intf/done_encryption

####################### Decryption Signals ##########################
add wave -noupdate -radix binary -group {Decryption signals}        /aes_tb/tb_intf/start_decryption
add wave -noupdate -radix hexadecimal -group {Decryption signals}   /aes_tb/tb_intf/cyphertext_decryption
add wave -noupdate -radix binary -group {Decryption signals}        /aes_tb/tb_intf/done_decyption
add wave -noupdate -radix hexadecimal -group {Decryption signals}   /aes_tb/tb_intf/plaintext_decryption

####################### Waveviewer configuration ##########################
TreeUpdate [SetDefaultTree]
configure wave -signalnamewidth 1
configure wave -justifyvalue left
configure wave -timelineunits ns
configure wave -timeline 0
WaveRestoreZoom {0 ps} {140 ns}
update
