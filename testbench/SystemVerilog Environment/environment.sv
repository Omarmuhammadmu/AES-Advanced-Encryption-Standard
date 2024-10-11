/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : environment.sv
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
   PURPOSE : environment class of the SV-environment-based testbench
   -FHDR------------------------------------------------------------------------*/

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  
  //generator and driver instance
  generator 	gen;
  driver    	driv;
  monitor   	mon;
  scoreboard	scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //virtual interface
  virtual aes_interface vif;
  
  //constructor
  function new(virtual aes_interface vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb  = new();
    
    //creating generator and driver
    gen  = new(gen2driv);
    driv = new(vif,gen2driv);
    mon  = new(vif,mon2scb);
    scb  = new(mon2scb);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
    if(scb.false_response == 0) begin
      $display("\n***************************************");
      $display("                  :)");
      $display("The results match the Golden Reference");
      $display("**************************************");
    end
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $stop;
  endtask
endclass