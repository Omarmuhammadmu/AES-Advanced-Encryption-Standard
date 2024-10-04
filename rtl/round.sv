import aes_package::*;

module round #(
    parameter   LAST_ROUND = 0
)(
    input  logic [DATA_WIDTH-1:0] data,
    input  logic [DATA_WIDTH-1:0] key,
    output logic [DATA_WIDTH-1:0] cypherdata
);

genvar byte_index;

byte data_matrix [0:3][0:3];
byte key_matrix [0:3][0:3];
byte sub_bytes_matrix [0:3][0:3];
byte shift_matrix [0:3][0:3];
byte mix_columns_matrix [0:3][0:3];
byte round_key_matrix [0:3][0:3];


genvar row_index, column_index;
//, byte_msb, byte_lsb
// Matrix organizing
generate
    for(column_index = 0; column_index < 4; column_index++) begin :data_arrange_column_loop
        for(row_index = 0; row_index < 4; row_index++) begin :data_arrange_row_loop
            localparam int byte_msb = DATA_WIDTH - (32 * column_index) - (1 + (row_index * 8));
            // localparam int byte_lsb = DATA_WIDTH - (32 * column_index) - (8 + (row_index * 8));
            always_comb begin : assign_always
                data_matrix[row_index][column_index] = data[(byte_msb) -: 8];
                key_matrix[row_index][column_index] = key[(byte_msb) -: 8]; 
            end
        end
    end
endgenerate

//Substitute Bytes stage
genvar i, j;
generate
    for(i = 0; i < 4 ; i++) begin : sub_byte_row_loop
        for(j = 0; j < 4 ; j++) begin : sub_byte_column_loop
            sbox u_sbox_round (.addr(data_matrix[i][j]), .dout(sub_bytes_matrix[i][j]));
        end
    end
endgenerate

// Shift row stage
integer shift_index, col_index;
bit [1:0] shift_value;
always @(*) begin
    for(shift_index = 0; shift_index<4; shift_index++) begin
        for(col_index = 0; col_index<4; col_index++) begin
            shift_value = shift_index + col_index; 
            shift_matrix[shift_index][col_index] = sub_bytes_matrix[shift_index][shift_value]; 
        end
    end
end

//Mix column stage
generate
    if(!LAST_ROUND) begin
        integer index;
        always @(*) begin
            for(index = 0; index < 4; index++) begin
                mix_columns_matrix[0][index] = (2 * shift_matrix[0][index]) ^ (3 * shift_matrix[1][index]) ^ (shift_matrix[2][index]) ^ (shift_matrix[3][index]);
                mix_columns_matrix[1][index] = (shift_matrix[0][index]) ^ (2 * shift_matrix[1][index]) ^ (3 * shift_matrix[2][index]) ^ (shift_matrix[3][index]);
                mix_columns_matrix[2][index] = (shift_matrix[0][index]) ^ (shift_matrix[1][index]) ^ (2 * shift_matrix[2][index]) ^ (3 * shift_matrix[3][index]);
                mix_columns_matrix[3][index] = (3 * shift_matrix[0][index]) ^ (shift_matrix[1][index]) ^ (shift_matrix[2][index]) ^ (2 * shift_matrix[3][index]);
            end
        end
    end
endgenerate

// ADD round key
genvar x, y;
generate
    for (x= 0; x<4; x++) begin : x_loop
        for (y= 0; y<4; y++) begin : y_loop
            localparam int byte_msb_o = DATA_WIDTH - (32 * x) - (1 + (y * 8));
            // localparam int byte_lsb_o = DATA_WIDTH - (32 * x) - (8 + (y * 8));
            always_comb begin
                if (!LAST_ROUND) begin
			        round_key_matrix[y][x] = mix_columns_matrix[y][x] ^ key_matrix[y][x];
                    cypherdata[(byte_msb_o) -:8] = round_key_matrix[y][x];
                end else begin
                    round_key_matrix[y][x] = shift_matrix[y][x] ^ key_matrix[y][x];
                    cypherdata[(byte_msb_o) -:8] = round_key_matrix[y][x];
                end
            end
        end
    end
endgenerate

endmodule
/* ------------------- End Of File -------------------*/