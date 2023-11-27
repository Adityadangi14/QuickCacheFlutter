import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:quick_cache_flutter/src/encryption/get_encryt_key_repo.dart';

class GetEncryptKeyRepoImpl implements GetEncryptKeyRepo {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  void storeCypher() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
    );
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    var containsEncryptionKey = await secureStorage.read(key: 'encryptionKey');
    logger.i(containsEncryptionKey);
    if (containsEncryptionKey != null) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(
          key: 'encryptionKey', value: base64UrlEncode(key));
    }
  }
}
