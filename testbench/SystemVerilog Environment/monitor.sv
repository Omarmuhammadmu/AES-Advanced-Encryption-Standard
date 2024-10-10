
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

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
        $display("---------------------\nInput capture time: %0t", $time);
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
        $display("Output capture time: %0t", $time);
        mon2scb.put(trans);
        trans.reportio();
      end
    endtask
  
endclass