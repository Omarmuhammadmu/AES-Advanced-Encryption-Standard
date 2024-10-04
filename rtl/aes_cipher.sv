/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : aes_chipher.sv
   DEPARTMENT : aes enrypthion
   AUTHOR : Omar Muhammad
   AUTHOR’S EMAIL : omarmuhammadmu0@gmail.com
   -----------------------------------------------------------------------------
   RELEASE HISTORY
   VERSION  DATE        AUTHOR      DESCRIPTION
   1.0      2024-10-5               initial version
   -----------------------------------------------------------------------------
   KEYWORDS : AES
   -----------------------------------------------------------------------------
   PURPOSE : Wrapper of aes cipher
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

module aes_cipher (
    input  logic                            clk,  
    input  logic                            rst,  
    input  logic                            start,
    input  logic [DATA_WIDTH-1:0]           plaintext,
    input  logic [EXPANSIONED_KEY_SIZE-1:0] round_keys,
    output logic [DATA_WIDTH-1:0]           cyphertext,
    output logic                            done
);
/*----------------------------------------------------------
        Internal signals and variables declarations
------------------------------------------------------------*/
logic [DATA_WIDTH-1:0]  pre_first_round;
logic [DATA_WIDTH-1:0]  round_key              [0 : NUM_OF_ROUNDS];
logic [DATA_WIDTH-1:0]  internal_cypherdata    [0 : NUM_OF_ROUNDS - 2];
logic [DATA_WIDTH-1:0]  plaintext_q;
logic [DATA_WIDTH-1:0]  cyphertext_c;
logic                   delay_reg;

genvar key_num;
genvar round_num;

/*----------------------------------------------------------
            Registering input and output
------------------------------------------------------------*/
// Register input and output
always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        done        <= 'b0;
        delay_reg   <= 'b0;
        cyphertext  <= 'b0;
        plaintext_q <= 'b0;
    end else begin
        if(start) begin
            plaintext_q <= plaintext;
        end

        if (delay_reg) begin
            cyphertext <= cyphertext_c;
        end
        
        done        <= delay_reg;
        delay_reg   <= start;
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
assign pre_first_round = plaintext_q ^ round_key [0];
/*----------------------------------------------------------
                    Rounds generator
------------------------------------------------------------*/
generate
    for (round_num = 0; round_num < NUM_OF_ROUNDS; round_num++) begin :round_generator_loop
        if (round_num == 0) begin
            round #(.LAST_ROUND(0)) u_first_round (
                .data(pre_first_round),
                .key(round_key[round_num + 1]),
                .cypherdata(internal_cypherdata[round_num])
            );
        end else if(round_num == (NUM_OF_ROUNDS - 1)) begin
            round #(.LAST_ROUND(1)) u_last_round (
                .data(internal_cypherdata[round_num - 1]),
                .key(round_key[round_num + 1]),
                .cypherdata(cyphertext_c)
            );
        end else begin
            round #(.LAST_ROUND(0)) u_internal_rounds (
                .data(internal_cypherdata[round_num - 1]),
                .key(round_key[round_num + 1]),
                .cypherdata(internal_cypherdata[round_num])
            );
        end
    end
endgenerate

endmodule
/* ------------------- End Of File -------------------*/