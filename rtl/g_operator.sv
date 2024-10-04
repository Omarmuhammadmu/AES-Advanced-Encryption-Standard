import aes_package::*;

module g_operator #(
    parameter ROUND_NUM = 0
)(
    input logic [WORD_SIZE-1:0] w,
    output logic [WORD_SIZE-1:0] g_w
);
// Component and variables
byte shifted_word [3:0];
byte sboxed_word [3:0];
genvar s_box_index;
/*g_operator implementation*/
// Shifting the input word by a byte to the left
assign {shifted_word[3],shifted_word[2],shifted_word[1],shifted_word[0]} = {w[23:16],w[15:8],w[7:0],w[31:24]};

generate
    // SBox encoding
    for (s_box_index = 0; s_box_index < 4; s_box_index++) begin : sbox_gen_loop
        sbox u_sbox (.addr(shifted_word[s_box_index]), .dout(sboxed_word[s_box_index]));
    end
endgenerate

generate
    //RoundConstant xors
    if(ROUND_NUM == 0) begin
        assign g_w = {(sboxed_word[3] ^ (8'h01)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 1) begin
        assign g_w = {(sboxed_word[3] ^ (8'h02)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 2) begin
        assign g_w = {(sboxed_word[3] ^ (8'h04)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 3) begin
        assign g_w = {(sboxed_word[3] ^ (8'h08)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 4) begin
        assign g_w = {(sboxed_word[3] ^ (8'h10)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 5) begin
        assign g_w = {(sboxed_word[3] ^ (8'h20)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 6) begin
        assign g_w = {(sboxed_word[3] ^ (8'h40)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 7) begin
        assign g_w = {(sboxed_word[3] ^ (8'h80)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 8) begin
        assign g_w = {(sboxed_word[3] ^ (8'h1B)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else if(ROUND_NUM == 9) begin
        assign g_w = {(sboxed_word[3] ^ (8'h36)),sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end else begin
        assign g_w = {sboxed_word[3],sboxed_word[2],sboxed_word[1],sboxed_word[0]};
    end    
endgenerate

endmodule
/* ------------------- End Of File -------------------*/