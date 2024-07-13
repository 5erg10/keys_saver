import 'package:encrypt/encrypt.dart';

class EncrypterService {
  static final _key = Key.fromUtf8('private key with 32 letters */+-');
  static final _iv = IV.allZerosOfLength(16);
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  static String encrypt(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch(e) {
      return plainText;
    }
  }

  static String decrypt(String encryptedText) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
      return decrypted;
    } catch (e) {
      return encryptedText;
    }
  }
}