import 'package:encrypt/encrypt.dart';

class EncrypterService {

  static String encrypt(String plainText, String ncrK) {
    try {
      final key = Key.fromUtf8(ncrK);
      final iv = IV.allZerosOfLength(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      
      return encrypted.base64;
    } catch(e) {
      return plainText;
    }
  }

  static String decrypt(String encryptedText, String ncrK) {
    
    final key = Key.fromUtf8(ncrK);
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    
    try {
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted;
    } catch (e) {
      return encryptedText;
    }
  }
}