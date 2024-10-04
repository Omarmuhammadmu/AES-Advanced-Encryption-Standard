/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : aes.sv
   DEPARTMENT : aes wrapper
   AUTHOR : Omar Muhammad
   AUTHOR’S EMAIL : omarmuhammadmu0@gmail.com
   -----------------------------------------------------------------------------
   RELEASE HISTORY
   VERSION  DATE        AUTHOR      DESCRIPTION
   1.0      2024-10-5               initial version
   -----------------------------------------------------------------------------
   KEYWORDS : AES
   -----------------------------------------------------------------------------
   PURPOSE : Wrapper of aes
   -----------------------------------------------------------------------------
   PARAMETERS
   PARAM NAME   : RANGE   : DESCRIPTION         : DEFAULT   : UNITS
   N/A          : N/A     : N/A                 : N/A       : N/A 
   -----------------------------------------------------------------------------
   REUSE ISSUES
   Reset Strategy   : 
   Clock Domains    : 
   Critical Timing  : 
   Test Features    : 
   Asynchronous I/F : 
   Scan Methodology : 
   Instantiations   : 
   Synthesizable    : Y
   Other            : 
   -FHDR------------------------------------------------------------------------*/
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
/*----------------------------------------------------------
                    Instantiations
------------------------------------------------------------*/
//Chiper
aes_cipher u_aes_cipher
(
    .clk        (clk),  
    .rst        (rst),
    .start      (start_encryption),
    .plaintext  (plaintext_encryption),
    .round_keys (expansioned_key),
    .cyphertext (cyphertext_encryption),
    .done       (done_encryption)
);

// Key expansion
key_expansion u_key_expansion
(
    .key                (key_encryption),
    .expansioned_key    (expansioned_key)
);

// Dicipher

endmodule
/* ------------------- End Of File -------------------*/