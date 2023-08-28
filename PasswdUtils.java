package testDataMaker;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.junit.Test;

public class PasswdUtils {

  /** 秘密鍵. */
  private static final String secretKeyString = "1234567890123456";
  /** 初期化ベクトル . */
  private static final String IvParameterSpecString = "abcdefghijklmnop";
  /** 文字列 UTF8. */
  private static final String charset = "UTF-8";

  public static byte[] encrypto(String plainText) throws Exception {

    // 書式:"アルゴリズム/ブロックモード/パディング方式"
    Cipher encrypter = Cipher.getInstance("AES/CBC/PKCS5Padding");
    SecretKeySpec key = new SecretKeySpec(secretKeyString.getBytes(charset), "AES");
    IvParameterSpec iv = new IvParameterSpec(IvParameterSpecString.getBytes(charset));
    encrypter.init(Cipher.ENCRYPT_MODE, key, iv);

    return encrypter.doFinal(plainText.getBytes());
  }

  public static String decrypto(byte[] cryptoText) throws Exception {

    // 書式:"アルゴリズム/ブロックモード/パディング方式"
    Cipher decrypter = Cipher.getInstance("AES/CBC/PKCS5Padding");
    SecretKeySpec key = new SecretKeySpec(secretKeyString.getBytes(charset), "AES");
    IvParameterSpec iv = new IvParameterSpec(IvParameterSpecString.getBytes(charset));
    decrypter.init(Cipher.DECRYPT_MODE, key, iv);

    return new String(decrypter.doFinal(cryptoText));
  }

  ///////////////////////////使用例////////////////////////////////////////////////////////

  @Test
  public void testSample() throws Exception {
    String inputpass = "aaaaaaaaaaaaa";
    // 暗号化
    byte[] hashPass = PasswdUtils.encrypto(inputpass);

    System.out.println(hashPass);

    // 復号化
    String decrypedPass = PasswdUtils.decrypto(hashPass);
    System.out.println(decrypedPass);

  }

}
