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

logic [DATA_WIDTH-1:0] pre_first_round;
logic [DATA_WIDTH-1:0] round_key [0 : NUM_OF_ROUNDS];
logic [DATA_WIDTH-1:0] internal_cypherdata [0 : NUM_OF_ROUNDS - 2];
logic [DATA_WIDTH-1:0]           plaintext_q;
logic [DATA_WIDTH-1:0]           cyphertext_c;
logic [1:0]                      shift_regs;

// Key division loop
genvar key_num;
// Matrix organizing
generate
    for(key_num = 0; key_num < (NUM_OF_ROUNDS + 1); key_num++) begin :key_division_loop
        always_comb begin : assign_always
            round_key [key_num] = round_keys[((EXPANSIONED_KEY_SIZE - 1) - (key_num * DATA_WIDTH)) -:DATA_WIDTH]; 
        end
    end
endgenerate

// Add inital round key
assign pre_first_round = plaintext_q ^ round_key [0];
// assign cyphertext = cyphertext_q;
// Round generator
genvar round_num;
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

// Register input and output
assign done = shift_regs [1];
always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        plaintext_q <= 'b0;
        cyphertext <= 'b0;
        shift_regs <= 'b0;
    end else begin
        if(start) begin
            plaintext_q <= plaintext;
        end

        if (shift_regs [0]) begin
            cyphertext <= cyphertext_c;
        end

        shift_regs [0] <= start;
        shift_regs [1] <= shift_regs [0];
    end
end
endmodule
/* ------------------- End Of File -------------------*/