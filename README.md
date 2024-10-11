# AES-Advanced-Encryption-Standard
<p align="center">
   <img src="https://github.com/user-attachments/assets/d4101834-3036-4940-9d2d-6e11dbf992c3" border="0" width="400" />
</p>

AES-128 is a symmetric encryption algorithm standardized by the National Institute of Standards and Technology (NIST). It operates on fixed block sizes of 128 bits and employs a 128-bit key to encrypt and decrypt data securely. AES-128 is widely used for securing sensitive data due to its strong encryption, efficiency, and resistance to most known attacks.

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
![aes synthesis using quartus](https://github.com/user-attachments/assets/7d2ccc31-4d6f-4387-8a46-ecc3949bec18)

# Simple testbench waveform
![dumpy test waveform](https://github.com/user-attachments/assets/b7aab423-1ff3-4ea6-85b4-201c61fb409b)

# SystemVerilog-Environment-base testbench detailes
- Testbench illustration diagram
<p align="center">
   <img src="https://github.com/user-attachments/assets/e424efeb-3a49-4e8a-93ce-83f0dbf8f0d9" />
</p>
