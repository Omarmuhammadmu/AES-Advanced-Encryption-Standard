/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : random_test.sv
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
   PURPOSE : test class of the SV-environment-based testbench
   -FHDR------------------------------------------------------------------------*/

`include "environment.sv"
program test(aes_interface i_intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(i_intf);
    
    //setting the repeat count of generator and driver
    env.gen.repeat_count = 10;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram