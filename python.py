from hashlib import pbkdf2_hmac
from base64 import b64encode
from secrets import token_bytes

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding

def main():
    secret = b'Hello, World!'

    password = b'SECRET'
    salt = token_bytes(8)
    key_iv = pbkdf2_hmac('sha256', password, salt, 1000, 48)
    key = key_iv[:32]
    iv = key_iv[32:]

    paddr = padding.PKCS7(32).padder()
    cipher = Cipher(algorithms.AES256(key), modes.CBC(iv))
    enc = cipher.encryptor()
    cipher_text = enc.update(paddr.update(secret) + paddr.finalize()) + enc.finalize()
    print(b64encode(b'Salted__' + salt + cipher_text).decode())

if __name__ == '__main__':
    main()
