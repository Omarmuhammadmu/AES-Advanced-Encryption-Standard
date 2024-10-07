import aes_package::*;

module tb_aes;
    
    // Testbench signals
    logic clk;
    logic rst;
    logic start_encryption;
    logic start_decryption;
    logic [DATA_WIDTH-1:0] plaintext_encryption;
    logic [DATA_WIDTH-1:0] cyphertext_decryption;
    logic [DATA_WIDTH-1:0] key_encryption;
    logic [DATA_WIDTH-1:0] cyphertext_encryption;
    logic [DATA_WIDTH-1:0] plaintext_decryption;
    logic done_encryption;
    logic done_decyption;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock period (10 ns cycle)
    end

    // Instantiate the AES module
    aes u_aes (
        .clk (clk),
        .rst (rst),
        .start_encryption (start_encryption),
        .start_decryption(start_decryption),
        .plaintext_encryption (plaintext_encryption),
        .cyphertext_decryption(cyphertext_decryption),
        .key_encryption (key_encryption),
        .cyphertext_encryption (cyphertext_encryption),
        .plaintext_decryption(plaintext_decryption),
        .done_encryption (done_encryption),
        .done_decyption (done_decyption)
    );

    // Stimulus
    initial begin
        // Initial conditions
        rst = 0;
        start_encryption = 0;
        start_decryption = 0;
        cyphertext_decryption = 0;
        plaintext_encryption = 128'h00000101030307070f0f1f1f3f3f7f7f;
        key_encryption = 128'h00000000000000000000000000000000;
        
        // Reset sequence
        #20 rst = 1;  // Deassert reset after 10ns

        // Start AES encryption process
        #20 
        start_encryption = 1; // Assert start signal
        #10
        start_encryption = 0; // Deassert start after 10ns

        // Wait for encryption to complete
        wait(done_encryption);

        // Display the results
        $display("Plaintext:  %h", plaintext_encryption);
        $display("Key:        %h", key_encryption);
        $display("Ciphertext: %h", cyphertext_encryption);
        
        #10
        cyphertext_decryption = cyphertext_encryption;
        // Decryption
        #20 
        start_decryption = 1;
        #10
        start_decryption = 0;

        wait(done_decyption);

        // Display the results
        $display("Plaintext:  %h", plaintext_decryption);
        $display("Key:        %h", key_encryption);
        $display("Ciphertext: %h", cyphertext_decryption);

        if(plaintext_decryption == plaintext_encryption) begin
            $display("MATCHED :)))))))))");
        end
        // End the simulation
        #50 $stop;
    end

endmodule