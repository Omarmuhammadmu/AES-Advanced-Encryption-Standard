interface aes_interface (input logic clk, input logic rst);
    import aes_package::*; 
    logic                    start_encryption;
    logic                    start_decryption;
    logic [DATA_WIDTH-1:0]   plaintext_encryption;
    logic [DATA_WIDTH-1:0]   cyphertext_decryption;
    logic [DATA_WIDTH-1:0]   key_encryption;
    logic [DATA_WIDTH-1:0]   cyphertext_encryption;
    logic [DATA_WIDTH-1:0]   plaintext_decryption;
    logic                    done_encryption;
    logic                    done_decyption;

    modport aes_intf (
        input  clk,  
        input  rst,  
        input  start_encryption,
        input  start_decryption,
        input  plaintext_encryption,
        input  cyphertext_decryption,
        input  key_encryption,
        output cyphertext_encryption,
        output plaintext_decryption,
        output done_encryption,
        output done_decyption
    );

    modport aes_tb_intf (
        input cyphertext_encryption,
        input plaintext_decryption,
        input done_encryption,
        input done_decyption,
        // input clk,  
        // input rst,  
        output start_encryption,
        output start_decryption,
        output plaintext_encryption,
        output cyphertext_decryption,
        output key_encryption
    );

endinterface //aes_interface