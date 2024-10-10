import aes_package::*;

class transaction;
    //declaring the transaction items
    rand bit [DATA_WIDTH-1 : 0] plainText;
    rand bit [DATA_WIDTH-1 : 0] cipherText;
    rand bit [DATA_WIDTH-1 : 0] aes_key;
    rand bit start_encryption;
    rand bit start_decryption;
    bit [DATA_WIDTH-1 : 0] decryption_plainText;
    bit [DATA_WIDTH-1 : 0] encryption_cipherText;


    function void display(integer transaction_num, string file_dir);
        integer transaction_report = $fopen(file_dir, "a");
        $fdisplay(transaction_report, "\n-------------- Transaction #%0d --------------", transaction_num);
        $fdisplay(transaction_report, " Key text: %0h ", aes_key);
        $fdisplay(transaction_report, " %0d%0d ", start_encryption,start_decryption);
        if(start_encryption) begin
            $fdisplay(transaction_report, " Plain text: %0h ", plainText);
        end
        if(start_decryption) begin
            $fdisplay(transaction_report, " Cipher text: %0h ", cipherText);
        end
        $fclose(transaction_report);
    endfunction

    function void golden_ref_input(string file_dir);
        integer golden_ref_input_file = $fopen(file_dir, "a");
        if(start_encryption) begin
            $fdisplay(golden_ref_input_file, "e");
            $fdisplay(golden_ref_input_file, "%0h", aes_key);
            $fdisplay(golden_ref_input_file, "%0h", plainText);
        end
        if(start_decryption) begin
            $fdisplay(golden_ref_input_file, "d");
            $fdisplay(golden_ref_input_file, "%0h", aes_key);
            $fdisplay(golden_ref_input_file, "%0h", cipherText);
        end
        $fclose(golden_ref_input_file);
    endfunction

    function void reportio;
        static integer cntr = 0;
        string file_dir = "Environment_reports/dut_io_final_rpt.txt";
        integer io_rpt_file = $fopen(file_dir, "a");
        $fdisplay(io_rpt_file,"------ Transaction #%0d ------",cntr);
        if(start_encryption) begin
            $fdisplay(io_rpt_file, "Key: %0h", aes_key);
            $fdisplay(io_rpt_file, "i_plainText:%0h", plainText);
            $fdisplay(io_rpt_file, "o_CipherText:%0h", encryption_cipherText);
        end
        if(start_decryption) begin
            $fdisplay(io_rpt_file, "Key: %0h", aes_key);
            $fdisplay(io_rpt_file, "i_CipherText:%0h", cipherText);
            $fdisplay(io_rpt_file, "o_plainText:%0h", decryption_plainText);
        end
        if(!start_encryption && !start_decryption) begin
            $fdisplay(io_rpt_file,"No output");
        end
        $fclose(io_rpt_file);
        cntr++;
    endfunction
endclass //transaction