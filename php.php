<?php
$secret = "Hello, World!";

$password = "SECRET";
$salt = random_bytes(8);
$key_iv = openssl_pbkdf2($password, $salt, 48, 1000, "sha256");
$key = substr($key_iv, 0, 32);
$iv = substr($key_iv, 32);
$cipher_text = openssl_encrypt($secret, "aes-256-cbc", $key, OPENSSL_RAW_DATA, $iv);
$result = base64_encode("Salted__{$salt}{$cipher_text}");
echo $result, PHP_EOL;
?>
