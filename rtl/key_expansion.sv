import aes_package::*;

module key_expansion (
input  logic [DATA_WIDTH-1:0] key,
output logic [EXPANSIONED_KEY_SIZE-1:0] expansioned_key
);

genvar expan_num;
logic [WORD_SIZE-1:0] g_w [0:NUM_OF_ROUNDS-1];
// divide in words the input key
assign expansioned_key [EXPANSIONED_KEY_SIZE-1 -: DATA_WIDTH] = key;
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