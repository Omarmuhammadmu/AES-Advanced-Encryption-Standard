import aes_package::*;

module aes_tb;
    
    // Testbench signals
    logic clk;
    logic rst;
    aes_interface tb_intf (.clk(clk), .rst(rst));

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock period (10 ns cycle)
    end

    // Instantiate the AES module
    aes u_aes (.intf(tb_intf));

    // Stimulus
    initial begin
        // Initial conditions
        rst = 0;
        tb_intf.start_encryption = 0;
        tb_intf.start_decryption = 0;
        tb_intf.cyphertext_decryption = 0;
        tb_intf.plaintext_encryption = 128'h00000101030307070f0f1f1f3f3f7f7f;
        tb_intf.key_encryption = 128'h00000000000000000000000000000000;
        
        // Reset sequence
        #20 rst = 1;  // Deassert reset after 10ns

        // Start AES encryption process
        #20 
        tb_intf.start_encryption = 1; // Assert start signal
        #10
        tb_intf.start_encryption = 0; // Deassert start after 10ns

        // Wait for encryption to complete
        wait(tb_intf.done_encryption);

        // Display the results
        $display("Plaintext:  %h", tb_intf.plaintext_encryption);
        $display("Key:        %h", tb_intf.key_encryption);
        $display("Ciphertext: %h", tb_intf.cyphertext_encryption);
        
        #10
        tb_intf.cyphertext_decryption = tb_intf.cyphertext_encryption;
        // Decryption
        #20 
        tb_intf.start_decryption = 1;
        #10
        tb_intf.start_decryption = 0;

        wait(tb_intf.done_decyption);

        // Display the results
        $display("Plaintext:  %h", tb_intf.plaintext_decryption);
        $display("Key:        %h", tb_intf.key_encryption);
        $display("Ciphertext: %h", tb_intf.cyphertext_decryption);

        if(tb_intf.plaintext_decryption == tb_intf.plaintext_encryption) begin
            $display("MATCHED :)))))))))");
        end
        // End the simulation
        #50 $stop;
    end

endmodule