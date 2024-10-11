/* -----------------------------------------------------------------------------
   Copyright (c) Omar Muhammad Mustafa
   -----------------------------------------------------------------------------
   FILE NAME : testbench.sv
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
   PURPOSE : testbench top module of the SV-environment-based testbench
   -FHDR------------------------------------------------------------------------*/

`include "random_test.sv"

module tbench_top;
  localparam CLK_PERIOD = 10;

  //clock and reset signal declaration
  bit clk;
  bit rst;
  
  //clock generation
  always #(CLK_PERIOD/2) clk = ~clk;

  //reset Generation
  initial begin
    rst = 0;
    #(CLK_PERIOD/2) rst =1;
  end
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  aes_interface tb_intf (.clk(clk), .rst(rst));
  
  // Coverage
  // covergroup CovGrp @(posedge clk);
  //   coverpoint tb_intf.start_encryption;
  //   coverpoint tb_intf.start_decryption;
  // endgroup

  // CovGrp testcoverage = new();

  //Testcase instance, interface handle is passed to test as an argument
  test t1(tb_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  aes u_aes (.intf(tb_intf));
  
  //enabling the wave dump
  initial begin 
    $dumpfile("aes_sv_env.vcd"); $dumpvars;
  end
endmodule