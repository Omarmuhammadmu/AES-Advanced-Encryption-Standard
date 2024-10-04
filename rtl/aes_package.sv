/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : aes_package.sv
   DEPARTMENT : aes parameters
   AUTHOR : Omar Muhammad
   AUTHOR’S EMAIL : omarmuhammadmu0@gmail.com
   -----------------------------------------------------------------------------
   RELEASE HISTORY
   VERSION  DATE        AUTHOR      DESCRIPTION
   1.0      2024-10-5               initial version
   -----------------------------------------------------------------------------
   KEYWORDS : AES
   -----------------------------------------------------------------------------
   PURPOSE : package file
   -FHDR------------------------------------------------------------------------*/
package aes_package;
    parameter BYTE = 8;
    parameter WORD_SIZE = 32;
    parameter DATA_WIDTH = 128;
    parameter EXPANSIONED_KEY_SIZE = WORD_SIZE * 44;
    parameter NUM_OF_ROUNDS = 10;

    parameter MAT_NUM_ROW = 4;
    parameter MAT_NUM_COLUMN = 4;
endpackage
/* ------------------- End Of File -------------------*/