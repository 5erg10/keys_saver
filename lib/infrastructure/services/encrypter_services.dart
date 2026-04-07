import 'dart:convert';
import 'package:encrypt/encrypt.dart';

/// Formato del texto cifrado: "<iv_base64>:<ciphertext_base64>"
/// El IV se genera aleatoriamente en cada cifrado y se almacena junto al texto.
class EncrypterService {

  static String encrypt(String plainText, String ncrK) {
    final key = Key.fromUtf8(ncrK);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return '${iv.base64}:${encrypted.base64}';
  }

  static String decrypt(String encryptedText, String ncrK) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw FormatException('Formato de texto cifrado inválido: se esperaba "iv:ciphertext"');
    }

    final key = Key.fromUtf8(ncrK);
    final iv = IV(base64Decode(parts[0]));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    return encrypter.decrypt64(parts[1], iv: iv);
  }
}

