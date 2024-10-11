/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : scoreboard.sv
   DEPARTMENT : aes SV-environment-based verification 
   AUTHOR : Omar Muhammad
   AUTHOR’S EMAIL : omarmuhammadmu0@gmail.com
   -----------------------------------------------------------------------------
   RELEASE HISTORY
   VERSION  DATE        AUTHOR      DESCRIPTION
   1.0      2024-10-12              initial version
   -----------------------------------------------------------------------------
   KEYWORDS : AES, testbench, verification, SV-based-testbench
   -----------------------------------------------------------------------------
   PURPOSE : scoreboard class of the SV-environment-based testbench
   -FHDR------------------------------------------------------------------------*/

class scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;
  
  //used to count the number of transactions
  int no_transactions;
  
  int false_response;
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    string py_i_key_file_dir = "pyhton_work_files/key.txt";  
    string py_i_plaintext_file_dir = "pyhton_work_files/plaintext.txt";
    string py_i_ciphertext_file_dir = "pyhton_work_files/ciphertext.txt";
    string py_i_mode_file_dir = "pyhton_work_files/mode.txt";
    string py_o_ciphertext_file_dir = "pyhton_work_files/ciphertext.txt";
    string py_o_decrypted_file_dir = "pyhton_work_files/decrypted.txt";
    integer py_i_key_file, py_i_plaintext_file, py_i_ciphertext_file, py_i_mode_file, py_o_ciphertext_file, py_o_decrypted_file;

    bit [127:0] py_ciphertext;
    bit [127:0] py_decryptedtext;

    forever begin
      py_ciphertext = 'b0;
      py_decryptedtext = 'b0;
      mon2scb.get(trans);
      // Open key file
      py_i_key_file = $fopen(py_i_key_file_dir, "w");
      $fdisplay(py_i_key_file, "%32h", trans.aes_key);
      $fclose(py_i_key_file);

      //Generate the expected output from AES pyhton model.
      //If encyrption
      if(trans.start_encryption) begin
        // Opening Files
        py_i_plaintext_file = $fopen(py_i_plaintext_file_dir, "w");
        py_i_mode_file = $fopen(py_i_mode_file_dir, "w");
        py_o_ciphertext_file = $fopen(py_o_ciphertext_file_dir, "r");
        // Write data to be used in python model
        $fdisplay(py_i_mode_file, "1");
        $fclose(py_i_mode_file);
        $fdisplay(py_i_plaintext_file, "%32h",trans.plainText);
        $fclose(py_i_plaintext_file);
        // Execute pyhton model
        $system("python.exe ../testbench/aes_python_model/aes.py");
        // Read pyhton model output
        $fscanf(py_o_ciphertext_file, "%h", py_ciphertext);
        // $display("Read ciphertext from pyhton: %0h", py_ciphertext);
        // Close opened files
        $fclose(py_o_ciphertext_file);
        // Scoreboard informing
        if(py_ciphertext == trans.encryption_cipherText) begin
          $display("[Scoreboard: Transaction #%0d] Encyption result is as Expected", no_transactions);
        end else begin
          $error("[Scoreboard: Transaction #%0d] Encyption: Wrong Result.\n\tExpeced: %0h Actual: %0h",no_transactions,py_ciphertext,trans.encryption_cipherText);
          false_response++;
        end
      end

      //If Decryption
      if(trans.start_decryption) begin
        // Opening Files
        py_i_ciphertext_file = $fopen(py_i_ciphertext_file_dir, "w");
        py_i_mode_file = $fopen(py_i_mode_file_dir, "w");
        py_o_decrypted_file = $fopen(py_o_decrypted_file_dir, "r");
        // Write data to be used in python model
        $fdisplay(py_i_mode_file, "0");
        $fclose(py_i_mode_file);
        $fdisplay(py_i_ciphertext_file, "%32h",trans.cipherText);
        $fclose(py_i_ciphertext_file);
        // Execute pyhton model
        $system("python.exe ../testbench/aes_python_model/aes.py");
        // Read pyhton model output
        $fscanf(py_o_decrypted_file, "%h", py_decryptedtext);
        // Close opened files
        $fclose(py_o_decrypted_file);
        // Scoreboard informing
        if(py_decryptedtext == trans.decryption_plainText) begin
          $display("[Scoreboard: Transaction #%0d] Descryption result is as Expected", no_transactions);
        end else begin
          $error("[Scoreboard: Transaction #%0d] Decyption: Wrong Result.\n\tExpeced: %0h Actual: %0h",no_transactions,py_decryptedtext,trans.decryption_plainText); 
          false_response++;
        end
      end
      no_transactions++;
    end
  endtask
endclass