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

module aes(aes_interface.aes_intf intf);

logic [EXPANSIONED_KEY_SIZE-1:0] expansioned_key;
/*----------------------------------------------------------
                    Instantiations
------------------------------------------------------------*/
//Chiper
aes_cipher u_aes_cipher(
    .clk        (intf.clk),  
    .rst        (intf.rst),
    .start      (intf.start_encryption),
    .plaintext  (intf.plaintext_encryption),
    .round_keys (expansioned_key),
    .cyphertext (intf.cyphertext_encryption),
    .done       (intf.done_encryption)
);

// Key expansion
key_expansion u_key_expansion(
    .clk                (intf.clk),
    .rst                (intf.rst),
    .key                (intf.key_encryption),
    .expansioned_key    (expansioned_key)
);

// Dicipher
aes_decipher u_aes_decipher(
    .clk        (intf.clk),  
    .rst        (intf.rst),  
    .start_dec  (intf.start_decryption),
    .cyphertext (intf.cyphertext_decryption),
    .round_keys (expansioned_key),
    .plaintext  (intf.plaintext_decryption),
    .done_dec   (intf.done_decyption)
);
endmodule
/* ------------------- End Of File -------------------*/