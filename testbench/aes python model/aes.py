from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
import binascii

# Function to perform AES encryption
def aes_encrypt(plaintext, key):
    # Create AES cipher object with key and ECB mode (Electronic Codebook)
    cipher = AES.new(key, AES.MODE_ECB)
    
    # Encrypt the plaintext
    ciphertext = cipher.encrypt(plaintext)
    
    return ciphertext

# Example usage
if __name__ == "__main__":
    # Convert the key and plaintext to bytes
    key = binascii.unhexlify('00000000000000000000000012345678')  # 128-bit key
    plaintext = binascii.unhexlify('00000101030307070f0f1f1f3f3f7f7f')  # 128-bit plaintext

    # Encrypt the plaintext
    ciphertext = aes_encrypt(plaintext, key)
    
    # Convert ciphertext to hex for display
    print(f"Plaintext:  {binascii.hexlify(plaintext).decode()}")
    print(f"Key:        {binascii.hexlify(key).decode()}")
    print(f"Ciphertext: {binascii.hexlify(ciphertext).decode()}")
