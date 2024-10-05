/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : round.sv
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
   PURPOSE : implementation of encryption round
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

module round #(
    parameter   LAST_ROUND = 0
)(
    input  logic [DATA_WIDTH-1:0] data,
    input  logic [DATA_WIDTH-1:0] key,
    output logic [DATA_WIDTH-1:0] cypherdata
);
/*----------------------------------------------------------
        Internal signals and variables declarations
------------------------------------------------------------*/
//Signals declarations
byte data_matrix                [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte key_matrix                 [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte sub_bytes_matrix           [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte mix_columns_matrix         [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte round_key_matrix           [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
bit [BYTE-1 :0] shift_matrix    [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];

//genvar declarations
//Matrix organizing genvar
genvar row_index, column_index;
//Substitute Bytes genvar
genvar i, j;
// Add round key genvar
genvar x, y;

/*----------------------------------------------------------
                    Matrix organizing
------------------------------------------------------------*/
generate
    for(column_index = 0; column_index < MAT_NUM_COLUMN; column_index++) begin :data_arrange_column_loop
        for(row_index = 0; row_index < MAT_NUM_ROW; row_index++) begin :data_arrange_row_loop
            localparam int byte_msb = DATA_WIDTH - (WORD_SIZE * column_index) - (1 + (row_index * BYTE));
            always_comb begin : assign_always
                data_matrix[row_index][column_index] = data[(byte_msb) -: BYTE];
                key_matrix[row_index][column_index] = key[(byte_msb) -: BYTE]; 
            end
        end
    end
endgenerate

/*----------------------------------------------------------
                Substitute Bytes stage
------------------------------------------------------------*/
generate
    for(i = 0; i < MAT_NUM_ROW ; i++) begin : sub_byte_row_loop
        for(j = 0; j < MAT_NUM_COLUMN ; j++) begin : sub_byte_column_loop
            sbox u_sbox_round (.addr(data_matrix[i][j]), .dout(sub_bytes_matrix[i][j]));
        end
    end
endgenerate

/*----------------------------------------------------------
                    Shift row stage
------------------------------------------------------------*/
integer shift_index, col_index;
bit [1:0] shift_value;
always @(*) begin
    for(shift_index = 0; shift_index<MAT_NUM_ROW; shift_index++) begin
        for(col_index = 0; col_index<MAT_NUM_COLUMN; col_index++) begin
            shift_value = shift_index + col_index; 
            shift_matrix[shift_index][col_index] = sub_bytes_matrix[shift_index][shift_value]; 
        end
    end
end

/*----------------------------------------------------------
                    Mix column stage
------------------------------------------------------------*/
// ------ Function declarations
// Multiplication by 0x02 under GF(2^8) 
function [BYTE-1:0] multx2;
    input [BYTE-1:0] multiplicand;
    begin
        multx2 = (multiplicand<<1) ^ ((multiplicand[7])? 8'h1b : 8'h00);
    end
endfunction

// Multiplication by 0x03 under GF(2^8) 
function [BYTE-1:0] multx3;
    input [BYTE-1:0] multiplicand;
    begin
        multx3 = multx2(multiplicand) ^ multiplicand;
    end
endfunction

// ------ Mix column logic generation
generate
    if(!LAST_ROUND) begin
        integer index;
        always @(*) begin
            for(index = 0; index < MAT_NUM_COLUMN; index++) begin
                mix_columns_matrix[0][index] = (multx2(shift_matrix[0][index])) ^ (multx3(shift_matrix[1][index])) ^ (shift_matrix[2][index]) ^ (shift_matrix[3][index]);
                mix_columns_matrix[1][index] = (shift_matrix[0][index]) ^ (multx2(shift_matrix[1][index])) ^ (multx3(shift_matrix[2][index])) ^ (shift_matrix[3][index]);
                mix_columns_matrix[2][index] = (shift_matrix[0][index]) ^ (shift_matrix[1][index]) ^ (multx2(shift_matrix[2][index])) ^ (multx3(shift_matrix[3][index]));
                mix_columns_matrix[3][index] = (multx3(shift_matrix[0][index])) ^ (shift_matrix[1][index]) ^ (shift_matrix[2][index]) ^ (multx2(shift_matrix[3][index]));
            end
        end
    end
endgenerate

/*----------------------------------------------------------
                    ADD round key
------------------------------------------------------------*/
generate
    for (x= 0; x<MAT_NUM_ROW; x++) begin : x_loop
        for (y= 0; y<MAT_NUM_COLUMN; y++) begin : y_loop
            localparam int byte_msb_o = DATA_WIDTH - (WORD_SIZE * x) - (1 + (y * BYTE));
            always_comb begin
                if (!LAST_ROUND) begin
			        cypherdata[(byte_msb_o) -:BYTE] = mix_columns_matrix[y][x] ^ key_matrix[y][x];
                end else begin
                    cypherdata[(byte_msb_o) -:BYTE] = shift_matrix[y][x] ^ key_matrix[y][x];
                end
            end
        end
    end
endgenerate

endmodule
/* ------------------- End Of File -------------------*/