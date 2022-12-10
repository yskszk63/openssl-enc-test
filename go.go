package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/sha256"
	"crypto/rand"
	"encoding/base64"
	"fmt"

	"golang.org/x/crypto/pbkdf2"
)

func pkcs7pad(b []byte, bs int) []byte {
	size := bs - (((len(b) - 1) % bs) + 1)
	pad := bytes.Repeat([]byte { byte(size) }, size)
	return append(b, pad...)
}

func main() {
	secret := "Hello, World!"

	password := "SECRET"
	salt := make([]byte, 8)
	if _, err := rand.Read(salt); err != nil {
		panic(err)
	}
	keyIv := pbkdf2.Key([]byte(password), salt, 1000, 48, sha256.New)
	key := keyIv[:32]
	iv := keyIv[32:]

	c, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}
	enc := cipher.NewCBCEncrypter(c, iv)
	padded := pkcs7pad([]byte(secret), aes.BlockSize)
	cipherText := make([]byte, len(padded))
	enc.CryptBlocks(cipherText, padded)

	result := []byte("Salted__")
	result = append(result, salt...)
	result = append(result, cipherText...)
	fmt.Println(base64.StdEncoding.EncodeToString(result))
}
