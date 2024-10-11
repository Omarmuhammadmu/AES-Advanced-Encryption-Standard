/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : generator.sv
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
   PURPOSE : generator class of the SV-environment-based testbench
   -FHDR------------------------------------------------------------------------*/

class generator;
    //declaring transaction class 
    rand transaction trans;

    //repeat count, to specify number of items to generate
    int  repeat_count;
  
    //mailbox, to generate and send the packet to driver
    mailbox gen2driv;

    //event, to indicate the end of transaction generation
    event ended;

    //constructor
    function new(mailbox gen2driv_constructor);
        //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
        this.gen2driv = gen2driv_constructor;
    endfunction
    
    //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
    task main();
        repeat(repeat_count) begin
            trans = new();
            if( !trans.randomize() ) $fatal("Gen:: trans randomization failed"); //To be done ussig assert
                gen2driv.put(trans);
        end
        -> ended; //triggering indicatesthe end of generation
    endtask
endclass //generator