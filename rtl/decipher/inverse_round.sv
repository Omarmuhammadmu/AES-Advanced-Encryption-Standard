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

module inverse_round #(
    parameter   LAST_ROUND = 0
)(
    input  logic [DATA_WIDTH-1:0] cypherdata,
    input  logic [DATA_WIDTH-1:0] key,
    output logic [DATA_WIDTH-1:0] plaintext
);
/*----------------------------------------------------------
        Internal signals and variables declarations
------------------------------------------------------------*/
//Signals declarations
byte inverse_data_matrix                [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte inverse_key_matrix                 [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte inverse_sub_bytes_matrix           [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
byte inverse_mix_columns_matrix         [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
bit [BYTE-1 :0] inverse_shift_matrix    [0:MAT_NUM_ROW][0:MAT_NUM_COLUMN];
logic [DATA_WIDTH-1:0] plaintext_temp;

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
                inverse_data_matrix[row_index][column_index] = cypherdata[(byte_msb) -: BYTE];
                inverse_key_matrix[row_index][column_index] = key[(byte_msb) -: BYTE]; 
            end
        end
    end
endgenerate

/*----------------------------------------------------------
                Inverse Shift row stage
------------------------------------------------------------*/
integer shift_index, col_index;
bit [1:0] shift_value;
always @(*) begin
    for(shift_index = 0; shift_index<MAT_NUM_ROW; shift_index++) begin
        for(col_index = 0; col_index<MAT_NUM_COLUMN; col_index++) begin
            if(shift_index [0]) begin
                shift_value = shift_index + col_index + 2; 
            end else begin
                shift_value = shift_index + col_index; 
            end
            inverse_shift_matrix[shift_index][col_index] = inverse_data_matrix[shift_index][shift_value]; 
        end
    end
end

/*----------------------------------------------------------
                Inverse Substitute Bytes stage
------------------------------------------------------------*/
generate
    for(i = 0; i < MAT_NUM_ROW ; i++) begin : inverse_sub_byte_row_loop
        for(j = 0; j < MAT_NUM_COLUMN ; j++) begin : inverse_sub_byte_column_loop
            inverse_sbox u_inverse_sbox_round (.addr(inverse_shift_matrix[i][j]), .dout(inverse_sub_bytes_matrix[i][j]));
        end
    end
endgenerate

/*----------------------------------------------------------
                Inverse ADD round key
------------------------------------------------------------*/
generate
    for (x= 0; x<MAT_NUM_ROW; x++) begin : inverse_x_loop
        for (y= 0; y<MAT_NUM_COLUMN; y++) begin : inverse_y_loop
            localparam int byte_msb_o = DATA_WIDTH - (WORD_SIZE * x) - (1 + (y * BYTE));
            always_comb begin
                if (!LAST_ROUND) begin
                    // Need matrix placement modification
			        inverse_mix_columns_matrix[y][x] = inverse_sub_bytes_matrix[y][x] ^ inverse_key_matrix[y][x];
                end else begin
                    plaintext_temp[(byte_msb_o) -:BYTE] = inverse_sub_bytes_matrix[y][x] ^ inverse_key_matrix[y][x];
                end
            end
        end
    end
endgenerate

/*----------------------------------------------------------
                Inverse Mix column stage
------------------------------------------------------------*/
// ------ Function declarations
// Multiplication by 0x02 under GF(2^8) n times 
function [BYTE-1:0] multxn2;
    input [BYTE-1:0] multiplicand;
    input integer n_times;
    begin
        integer i;
        // logic [BYTE-1:0] temp = multiplicand;
        for(i = 0; i<n_times; i++) begin
            // temp = (temp<<1) ^ ((temp[7])? 8'h1b : 8'h00);
            multiplicand = (multiplicand<<1) ^ ((multiplicand[7])? 8'h1b : 8'h00);
        end
        // multxn2 = temp;
        multxn2 = multiplicand;
    end
endfunction

// Multiplication by 0x0e under GF(2^8) 
function [BYTE-1:0] multx0e;
    input [BYTE-1:0] multiplicand;
    begin
        multx0e = multxn2 (multiplicand,3) ^ multxn2(multiplicand,2) ^ multxn2(multiplicand,1);
    end
endfunction

// Multiplication by 0x0b under GF(2^8) 
function [BYTE-1:0] multx0b;
    input [BYTE-1:0] multiplicand;
    begin
        multx0b = multxn2 (multiplicand,3) ^ multxn2(multiplicand,1) ^ multiplicand;
    end
endfunction

// Multiplication by 0x0d under GF(2^8) 
function [BYTE-1:0] multx0d;
    input [BYTE-1:0] multiplicand;
    begin
        multx0d = multxn2 (multiplicand,3) ^ multxn2(multiplicand,2) ^ multiplicand;
    end
endfunction

// Multiplication by 0x09 under GF(2^8) 
function [BYTE-1:0] multx09;
    input [BYTE-1:0] multiplicand;
    begin
        multx09 = multxn2 (multiplicand,3) ^ multiplicand;
    end
endfunction

// ------ Inverse Mix column logic generation
generate
    always @(*) begin
    if(!LAST_ROUND) begin
        integer index;
        for(index = 0; index < MAT_NUM_COLUMN; index++) begin
            plaintext[(DATA_WIDTH - (index * WORD_SIZE) - 1) -:BYTE]            = (multx0e(inverse_mix_columns_matrix[0][index])) ^ (multx0b(inverse_mix_columns_matrix[1][index])) ^ (multx0d(inverse_mix_columns_matrix[2][index])) ^ (multx09(inverse_mix_columns_matrix[3][index]));
            plaintext[(DATA_WIDTH - (BYTE) - (index * WORD_SIZE) - 1) -:BYTE]   = (multx09(inverse_mix_columns_matrix[0][index])) ^ (multx0e(inverse_mix_columns_matrix[1][index])) ^ (multx0b(inverse_mix_columns_matrix[2][index])) ^ (multx0d(inverse_mix_columns_matrix[3][index]));
            plaintext[(DATA_WIDTH - (2*BYTE) - (index * WORD_SIZE) - 1) -:BYTE] = (multx0d(inverse_mix_columns_matrix[0][index])) ^ (multx09(inverse_mix_columns_matrix[1][index])) ^ (multx0e(inverse_mix_columns_matrix[2][index])) ^ (multx0b(inverse_mix_columns_matrix[3][index]));
            plaintext[(DATA_WIDTH - (3*BYTE) - (index * WORD_SIZE) - 1) -:BYTE] = (multx0b(inverse_mix_columns_matrix[0][index])) ^ (multx0d(inverse_mix_columns_matrix[1][index])) ^ (multx09(inverse_mix_columns_matrix[2][index])) ^ (multx0e(inverse_mix_columns_matrix[3][index]));
        end
    end else begin
        plaintext = plaintext_temp;
    end
    end
endgenerate
endmodule
/* ------------------- End Of File -------------------*/