from Crypto.Cipher import AES
import binascii

# Function to perform AES encryption
def aes_encrypt(plaintext, key):
    # Create AES cipher object with key and ECB mode (Electronic Codebook)
    cipher = AES.new(key, AES.MODE_ECB)
    
    # Encrypt the plaintext
    ciphertext = cipher.encrypt(plaintext)
    
    return ciphertext

# Function to perform AES decryption
def aes_decrypt(ciphertext, key):
    # Create AES cipher object with key and ECB mode
    cipher = AES.new(key, AES.MODE_ECB)
    
    # Decrypt the ciphertext
    decrypted_plaintext = cipher.decrypt(ciphertext)
    
    return decrypted_plaintext
# Main function
if __name__ == "__main__":
    # Ask the user for operation mode: encryption or decryption
    mode = input("Enter 'e' for encryption or 'd' for decryption: ").lower()
    
    # Get the key from the user (hex input)
    key_input = input("Enter the 128-bit (16-byte) key in hexadecimal format: ")
    key = binascii.unhexlify(key_input)
    
    if mode == 'e':
        # Get plaintext from the user
        plaintext_input = input("Enter the plaintext in hexadecimal format: ")
        plaintext = binascii.unhexlify(plaintext_input)
        
        # Encrypt the plaintext
        ciphertext = aes_encrypt(plaintext, key)
        
        # Convert ciphertext to hex and display
        print(f"Ciphertext: {binascii.hexlify(ciphertext).decode()}")
    
    elif mode == 'd':
        # Get ciphertext from the user
        ciphertext_input = input("Enter the ciphertext in hexadecimal format: ")
        ciphertext = binascii.unhexlify(ciphertext_input)
        
        # Decrypt the ciphertext
        decrypted_plaintext = aes_decrypt(ciphertext, key)
        
        # Convert decrypted plaintext to hex and display
        print(f"Decrypted Plaintext: {binascii.hexlify(decrypted_plaintext).decode()}")
    
    else:
        print("Invalid option. Please enter 'e' for encryption or 'd' for decryption.")
