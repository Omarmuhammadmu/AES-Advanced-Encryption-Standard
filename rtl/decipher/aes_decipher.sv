/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : aes_dechipher.sv
   DEPARTMENT : aes decryption
   AUTHOR : Omar Muhammad
   AUTHOR’S EMAIL : omarmuhammadmu0@gmail.com
   -----------------------------------------------------------------------------
   RELEASE HISTORY
   VERSION  DATE        AUTHOR      DESCRIPTION
   1.0      2024-10-5               initial version
   -----------------------------------------------------------------------------
   KEYWORDS : AES
   -----------------------------------------------------------------------------
   PURPOSE : Wrapper of aes decipher
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

module aes_decipher (
    input  logic                            clk,  
    input  logic                            rst,  
    input  logic                            start_dec,
    input  logic [DATA_WIDTH-1:0]           cyphertext,
    input  logic [EXPANSIONED_KEY_SIZE-1:0] round_keys,
    output logic [DATA_WIDTH-1:0]           plaintext,
    output logic                            done_dec
);
/*----------------------------------------------------------
        Internal signals and variables declarations
------------------------------------------------------------*/
logic [DATA_WIDTH-1:0]  pre_first_round;
logic [DATA_WIDTH-1:0]  round_key              [0 : NUM_OF_ROUNDS];
logic [DATA_WIDTH-1:0]  internal_plaintext    [0 : NUM_OF_ROUNDS - 2];
logic [DATA_WIDTH-1:0]  cyphertext_q;
logic [DATA_WIDTH-1:0]  plaintext_c;
logic                   delay_reg;

genvar key_num;
genvar round_num;

/*----------------------------------------------------------
            Registering input and output
------------------------------------------------------------*/
// Register input and output
always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        done_dec     <= 'b0;
        delay_reg    <= 'b0;
        plaintext    <= 'b0;
        cyphertext_q <= 'b0;
    end else begin
        if(start_dec) begin
            cyphertext_q <= cyphertext;
        end

        if (delay_reg) begin
            plaintext <= plaintext_c;
        end
        
        done_dec    <= delay_reg;
        delay_reg   <= start_dec;
    end
end
/*----------------------------------------------------------
                    Key division loop
------------------------------------------------------------*/
generate
    for(key_num = 0; key_num < (NUM_OF_ROUNDS + 1); key_num++) begin :key_division_loop
        always_comb begin : assign_always
            round_key [key_num] = round_keys[((EXPANSIONED_KEY_SIZE - 1) - (key_num * DATA_WIDTH)) -:DATA_WIDTH]; 
        end
    end
endgenerate

/*----------------------------------------------------------
                    Add inital round key
------------------------------------------------------------*/
assign pre_first_round = cyphertext_q ^ round_key [NUM_OF_ROUNDS];
/*----------------------------------------------------------
                    Rounds generator
------------------------------------------------------------*/
generate
    for (round_num = 0; round_num < NUM_OF_ROUNDS; round_num++) begin :inverse_round_generator_loop
        if (round_num == 0) begin
            inverse_round #(.LAST_ROUND(1)) u_last_round (
                .cypherdata(internal_plaintext[round_num]),
                .key(round_key[round_num]),
                .plaintext(plaintext_c) //decrypted text
            );
        end else if(round_num == (NUM_OF_ROUNDS - 1)) begin
            inverse_round #(.LAST_ROUND(0)) u_first_round (
                .cypherdata(pre_first_round),
                .key(round_key[round_num]),
                .plaintext(internal_plaintext[round_num - 1]) //internal first
            );
        end else begin
            inverse_round #(.LAST_ROUND(0)) u_internal_rounds (
                .cypherdata(internal_plaintext[round_num]),
                .key(round_key[round_num]),
                .plaintext(internal_plaintext[round_num - 1]) // internal
            );
        end
    end
endgenerate
endmodule
/* ------------------- End Of File -------------------*/