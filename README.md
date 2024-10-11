# AES-Advanced-Encryption-Standard
<p align="center">
   <img src="https://github.com/user-attachments/assets/d4101834-3036-4940-9d2d-6e11dbf992c3" border="0" width="600" />
</p>

AES-128 is a symmetric encryption algorithm standardized by the National Institute of Standards and Technology (NIST). It operates on fixed block sizes of 128 bits and employs a 128-bit key to encrypt and decrypt data securely. AES-128 is widely used for securing sensitive data due to its strong encryption, efficiency, and resistance to most known attacks.

# AES-Advanced-Encryption-Standard Repo content
- RTL files of AES written in SystemVerilog HDL language.
- Simple testbench to initially check the function of the RTL code.
- SV Environment testbench with randomization of the inputs and the key and comparing the result with aes pyhton model.
- AES python model.
- .do files to be used in QuestaSim to compile and run the simulation.
- AES NIST standard PDF.
- Snapshots of the synthsized logic using Quartus Prime, SV environment illustraion, and waveforms of both proposed testbenches. 

# AES Algorithem overview
<p align="center">
  <img src="https://github.com/user-attachments/assets/b5708b66-67f5-463f-94fd-7f0518a286d3" border="0" width="300" />
</p>


The AES-128 encryption process consists of several stages:

- **Key Expansion**: The 128-bit key is expanded into multiple round keys.
- **Initial Round**: An XOR operation is performed between the plaintext and the first round key.
- **Main Rounds (10 total)**: Each round involves the following operations:
  - **SubBytes**: Byte-level substitution using a non-linear S-box.
  - **ShiftRows**: Row-level shifting to ensure diffusion.
  - **MixColumns**: Column-wise mixing to enhance data diffusion.
  - **AddRoundKey**: An XOR operation with the round key.
- **Final Round**: Similar to the main rounds, but without the MixColumns step.

# Synthesized block diagram using Quartus Prime
<p align="center">
   <img src="https://github.com/user-attachments/assets/7a561e31-1d87-4539-939d-6c17fe320c5d" border="0" width="900" />
</p>

# Simple testbench waveform
- Testbench summary: An input plain text and key is given to the AES module and on cyphering the text it´s given back to be decyphered and then the input plain text is compared with the dechyphered plain text. And the chiphered text is comapred with the expected value obtained from external website
- [Website] https://legacy.cryptool.org/en/cto/aes-step-by-step
<p align="center">
   <img src="https://github.com/user-attachments/assets/b7aab423-1ff3-4ea6-85b4-201c61fb409b" border="0" width="900" />
</p>

# SystemVerilog-Environment-base testbench detailes
- Testbench illustration diagram
<p align="center">
   <img src="https://github.com/user-attachments/assets/e424efeb-3a49-4e8a-93ce-83f0dbf8f0d9" />
</p>

- To control the number of testcases change the env.gen.repeat_count in environment.sv
  ```verilog
  ...
  //setting the repeat count of generator and driver
    env.gen.repeat_count = 30;
  ...
  ```

- QuestaSim Transcript for a randomized 10 transaction
<p align="center">
   <img src="https://github.com/user-attachments/assets/56f96cb0-2122-4c6c-b5ac-0008abaed1b5" border="0" width="900" />
</p>

- QuestaSim Waveviewer shot
<p align="center">
   <img src="https://github.com/user-attachments/assets/9a859b4a-3c24-46fa-a97c-5b94b48107b1" border="0" width="900" />
</p>
