import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.Writer;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;


public class Java {
    public static void main(String[] args) throws Exception {
        var secret = "Hello, World!";

        var password = "SECRET";
        var salt = new byte[8];
        SecureRandom.getInstanceStrong().nextBytes(salt);

        var keyFactory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        var keyIv = keyFactory.generateSecret(new PBEKeySpec(password.toCharArray(), salt, 1000, 48 * 8)).getEncoded();
        var key = new SecretKeySpec(keyIv, 0, 32, "AES");
        var iv = Arrays.copyOfRange(keyIv, 32, 48);

        var cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));
        var cipherText = cipher.doFinal(secret.getBytes());

        var noClose = new OutputStream() {
            OutputStream out = System.out;

            @Override
            public void close() { }

            @Override
            public void flush() throws IOException {
                this.out.flush();
            }

            @Override
            public void write(int arg0) throws IOException {
                this.out.write(arg0);
            }

            @Override
            public void write(byte[] b) throws IOException {
                this.out.write(b);
            }

            @Override
            public void write(byte[] arg0, int arg1, int arg2) throws IOException {
                this.out.write(arg0, arg1, arg2);
            }
        };
        try (var stream = new PrintStream(Base64.getEncoder().wrap(noClose))) {
            stream.print("Salted__");
            stream.write(salt);
            stream.write(cipherText);
        };
        System.out.println();
    }
}
