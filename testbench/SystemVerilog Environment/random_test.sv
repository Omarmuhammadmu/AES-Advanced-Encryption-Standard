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