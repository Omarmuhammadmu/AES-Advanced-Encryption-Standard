import aes_package::*;

module aes(
    input  logic                    clk,  
    input  logic                    rst,  
    input  logic                    start_encryption,
    input  logic [DATA_WIDTH-1:0]   plaintext_encryption,
    input  logic [DATA_WIDTH-1:0]   key_encryption,
    output logic [DATA_WIDTH-1:0]   cyphertext_encryption,
    output logic                    done_encryption
);

logic [EXPANSIONED_KEY_SIZE-1:0] expansioned_key;
// Cipher
aes_cipher u_aes_cipher (
    .clk (clk),  
    .rst (rst),
    .start (start_encryption),
    .plaintext (plaintext_encryption),
    .round_keys (expansioned_key),
    .cyphertext (cyphertext_encryption),
    .done (done_encryption)
);
// Key expansion
key_expansion u_key_expansion (
    .key(key_encryption),
    .expansioned_key(expansioned_key)
);

// Dicipher

endmodule
/* ------------------- End Of File -------------------*/