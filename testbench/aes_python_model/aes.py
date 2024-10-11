from Crypto.Cipher import AES
import binascii
import os
import logging

# Configure logging
logging.basicConfig(filename='aes_error.log', level=logging.ERROR,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Function to perform AES encryption
def aes_encrypt(plaintext, key):
    try:
        # Create AES cipher object with key and ECB mode (Electronic Codebook)
        cipher = AES.new(key, AES.MODE_ECB)
        
        # Encrypt the plaintext
        ciphertext = cipher.encrypt(plaintext)
        
        return ciphertext
    except Exception as e:
        logging.error("Encryption error: %s", str(e))
        raise

# Function to perform AES decryption
def aes_decrypt(ciphertext, key):
    try:
        # Create AES cipher object with key and ECB mode
        cipher = AES.new(key, AES.MODE_ECB)
        
        # Decrypt the ciphertext
        decrypted_plaintext = cipher.decrypt(ciphertext)
        
        return decrypted_plaintext
    except Exception as e:
        logging.error("Decryption error: %s", str(e))
        raise

# Main function
if __name__ == "__main__":
    try:
        # Directory where the files are located
        dir_path = 'D:/AES/AES-Advanced-Encryption-Standard/QuestaSim simulation/pyhton_work_files'

        # File paths in the directory
        key_file = os.path.join(dir_path, 'key.txt')
        plaintext_file = os.path.join(dir_path, 'plaintext.txt')
        ciphertext_file = os.path.join(dir_path, 'ciphertext.txt')
        mode_file = os.path.join(dir_path, 'mode.txt')  # File containing '1' for encryption or '0' for decryption
        decrypted_file = os.path.join(dir_path, 'decrypted.txt')  # File to store the decrypted plaintext

        # Read the mode from the mode file (1 = encryption, 0 = decryption)
        with open(mode_file, 'r') as f:
            mode = f.read().strip()

        # Read the key from the key file
        with open(key_file, 'r') as f:
            key_input = f.read().strip()
        key = binascii.unhexlify(key_input)

        if mode == '1':  # Encryption mode
            # Read the plaintext from the plaintext file
            with open(plaintext_file, 'r') as f:
                plaintext_input = f.read().strip()
            plaintext = binascii.unhexlify(plaintext_input)
            
            # Encrypt the plaintext
            ciphertext = aes_encrypt(plaintext, key)
            
            # Write the ciphertext to a file in hex format
            with open(ciphertext_file, 'w') as f:
                f.write(binascii.hexlify(ciphertext).decode())
            print(f"    [Python.exe] Ciphertext written to {ciphertext_file}")
        
        elif mode == '0':  # Decryption mode
            # Read the ciphertext from the ciphertext file
            with open(ciphertext_file, 'r') as f:
                ciphertext_input = f.read().strip()
            ciphertext = binascii.unhexlify(ciphertext_input)
            
            # Decrypt the ciphertext
            decrypted_plaintext = aes_decrypt(ciphertext, key)
            
            # Write the decrypted plaintext to a separate file
            with open(decrypted_file, 'w') as f:
                f.write(binascii.hexlify(decrypted_plaintext).decode())
            print(f"    [Python.exe] Decrypted plaintext written to {decrypted_file}")
        
        else:
            error_msg = "Invalid mode in mode.txt. Please enter '1' for encryption or '0' for decryption."
            print(f"    [Python.exe] {error_msg}")
            logging.error(error_msg)

    except Exception as e:
        logging.error("An unexpected error occurred: %s", str(e))
        print(f"    [Python.exe] An error occurred: {str(e)}")
