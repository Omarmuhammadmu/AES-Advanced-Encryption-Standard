
/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : monitor.sv
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
   PURPOSE : monitor class of the SV-environment-based testbench
   -FHDR------------------------------------------------------------------------*/

class monitor;

    //creating virtual interface handle
    virtual aes_interface vif;

    //creating mailbox handle
    mailbox mon2scb;

    //constructor
    function new(virtual aes_interface vif,mailbox mon2scb);
      //getting the interface
      this.vif = vif;
      //getting the mailbox handles from  environment 
      this.mon2scb = mon2scb;
    endfunction

    //Samples the interface signal and send the sample packet to scoreboard
    task main;
        string file_dir = "Environment_reports/dut_io_final_rpt.txt";
        integer io_report = $fopen(file_dir, "w");
        $fdisplay(io_report, "[ Monitor ] Main task Started");
        $fdisplay(io_report, "----------------------------");
        $fclose(io_report);
        @(posedge vif.clk);
      forever begin
        transaction trans;
        trans = new();
        @(negedge vif.clk);
        trans.aes_key               = vif.key_encryption;
        trans.plainText             = vif.plaintext_encryption;
        trans.cipherText            = vif.cyphertext_decryption;
        trans.start_encryption      = vif.start_encryption;
        trans.start_decryption      = vif.start_decryption;
        @(negedge vif.clk);
        @(negedge vif.clk);
        if(vif.done_encryption) begin
            trans.encryption_cipherText  = vif.cyphertext_encryption;
        end else begin
            trans.encryption_cipherText  = 0;
        end
        if(vif.done_decyption) begin
            trans.decryption_plainText  = vif.plaintext_decryption;
        end else begin
            trans.decryption_plainText  = 0;
        end
        mon2scb.put(trans);
        trans.reportio();
      end
    endtask
endclass