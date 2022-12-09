require 'openssl'
require 'base64'

secret = 'Hello, World!'

password = 'SECRET'
salt = ''
#salt = OpenSSL::Random.random_bytes(8)
iter = 1000
key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iter, 48, 'sha256')

cipher = OpenSSL::Cipher.new('aes-256-cbc')
cipher.encrypt
cipher.key = key_iv[0, 32]
cipher.iv = key_iv[32, 48]
cipher_text = cipher.update(secret) + cipher.final
puts Base64.encode64(cipher_text)
# puts Base64.encode64("Salted__#{salt}#{cipher_text}")
