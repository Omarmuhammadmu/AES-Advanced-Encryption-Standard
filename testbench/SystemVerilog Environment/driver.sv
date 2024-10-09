class driver;
  //used to count the number of transactions
  int no_transactions;
  //creating virtual interface handle
  virtual aes_interface vif;
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual aes_interface vif,mailbox driver_gen2driv_const_mailbox);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = driver_gen2driv_const_mailbox;
  endfunction

  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(!vif.rst);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.key_encryption        <= 0;
    vif.start_encryption      <= 0;
    vif.start_decryption      <= 0;
    vif.plaintext_encryption  <= 0;
    vif.cyphertext_decryption <= 0;
    wait(vif.rst);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask

  //drivers the transaction items to interface signals
  task main;
    string file_dir = "Environment_reports/transaction_report.txt";
    string golden_file_dir = "Environment_reports/golden_ref_inputs.txt";
    integer transaction_report = $fopen(file_dir, "w");
    $fdisplay(transaction_report, "[ Driver ] Main task Started");
    $fdisplay(transaction_report, "----------------------------");
    $fclose(transaction_report);

    forever begin
      transaction trans;
      gen2driv.get(trans);
      @(posedge vif.clk);
      vif.key_encryption        <= trans.aes_key;
      vif.start_encryption      <= trans.start_encryption;
      vif.start_decryption      <= trans.start_decryption;
      vif.plaintext_encryption  <= trans.plainText;
      vif.cyphertext_decryption <= trans.cipherText;
      trans.display(no_transactions,file_dir);
      trans.golden_ref_input(golden_file_dir);
      no_transactions++;
    end
  endtask
endclass //driver