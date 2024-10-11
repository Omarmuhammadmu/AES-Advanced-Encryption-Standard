//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor

class scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;
  
  //used to count the number of transactions
  int no_transactions;
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);
        //Generate the expected output from AES pyhton model.
        //If encyrption
        // Generate encryption data to be given to the pyhton code and write it in a txt file
        // Generate the Cipher text in pyhton and write it in a different txt file
        // Read the generated cipher text and compare it with the received one.

        //If Decryption
        // Generate decryption data to be given to the pyhton code and write it in a txt file
        // Generate the plain text in pyhton and write it in a different txt file
        // Read the generated plain text and compare it with the received one.
        
        if((trans.a+trans.b) == trans.c) begin
          // $display("Result is as Expected"); Display in a file
        end else begin
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(trans.a+trans.b),trans.c); 
        end
        no_transactions++;
    end
  endtask
  
endclass