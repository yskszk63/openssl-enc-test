<?php
$secret = "Hello, World!";

$password = "SECRET";
$key_iv = openssl_pbkdf2($password, "", 48, 1000, "sha256");
$key = substr($key_iv, 0, 32);
$iv = substr($key_iv, 32);
$cipher_text = openssl_encrypt($secret, "aes-256-cbc", $key, 0, $iv);
echo $cipher_text, PHP_EOL;
?>
