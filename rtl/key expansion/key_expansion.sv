/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : key_expansion.sv
   DEPARTMENT : aes key expansion
   AUTHOR : Omar Muhammad
   AUTHOR’S EMAIL : omarmuhammadmu0@gmail.com
   -----------------------------------------------------------------------------
   RELEASE HISTORY
   VERSION  DATE        AUTHOR      DESCRIPTION
   1.0      2024-10-5               initial version
   -----------------------------------------------------------------------------
   KEYWORDS : AES, Key_Expansion
   -----------------------------------------------------------------------------
   PURPOSE : Implementaion of Key expansion module
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

module key_expansion (
    input  logic                            clk, 
    input  logic                            rst, 
    input  logic [DATA_WIDTH-1:0]           key,
    output logic [EXPANSIONED_KEY_SIZE-1:0] expansioned_key
);
/*----------------------------------------------------------
        Internal signals and variables declarations
------------------------------------------------------------*/
genvar expan_num;
logic [WORD_SIZE-1:0] g_w [0:NUM_OF_ROUNDS-1];
logic [DATA_WIDTH-1:0]           key_q;

/*----------------------------------------------------------
                Registering the input key
------------------------------------------------------------*/
always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        key_q <= 'b0;
    end else begin
        key_q <= key;
    end
end
/*----------------------------------------------------------
                Key espansion implementation
------------------------------------------------------------*/
// Original key assigning
assign expansioned_key [EXPANSIONED_KEY_SIZE-1 -: DATA_WIDTH] = key_q;

// g_operator and expansion stages
generate
    for(expan_num = 0; expan_num < NUM_OF_ROUNDS; expan_num++) begin : expansion_loop
        localparam int word_msb_index = EXPANSIONED_KEY_SIZE - DATA_WIDTH * (expan_num + 1);
        g_operator #(.ROUND_NUM(expan_num)) g_op (.w(expansioned_key[(word_msb_index + DATA_WIDTH -1)-96 -:WORD_SIZE]), .g_w(g_w[expan_num]));
        always_comb begin
            expansioned_key[word_msb_index-1 -:WORD_SIZE]  = (expansioned_key[(word_msb_index + DATA_WIDTH - 1) -:WORD_SIZE]) ^ (g_w[expan_num]); //First MSB word
            expansioned_key[word_msb_index-33 -:WORD_SIZE] = (expansioned_key[(word_msb_index + DATA_WIDTH - 1)-32 -:WORD_SIZE]) ^ (expansioned_key[word_msb_index-1 -:WORD_SIZE]); //Second MSB word
            expansioned_key[word_msb_index-65 -:WORD_SIZE] = (expansioned_key[(word_msb_index + DATA_WIDTH - 1)-64 -:WORD_SIZE]) ^ (expansioned_key[word_msb_index-33 -:WORD_SIZE]); //Third MSB word
            expansioned_key[word_msb_index-97 -:WORD_SIZE] = (expansioned_key[(word_msb_index + DATA_WIDTH - 1)-96 -:WORD_SIZE]) ^ (expansioned_key[word_msb_index-65 -:WORD_SIZE]); //Forth MSB word
        end
    end
endgenerate

endmodule
/* ------------------- End Of File -------------------*/