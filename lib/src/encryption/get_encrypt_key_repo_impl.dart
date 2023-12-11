import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/encryption/get_encryt_key_repo.dart';
import 'package:quick_cache_flutter/src/get_secure_storage_instance.dart';

class GetEncryptKeyRepoImpl implements GetEncryptKeyRepo {
  GetEncryptKeyRepoImpl._();

  static final instance = GetEncryptKeyRepoImpl._();

  GetSecureStorageInstance getSecureStorageInstance =
      GetSecureStorageInstance.instance;

  @override
  Future<void> storeCypher() async {
    var containsEncryptionKey =
        await getSecureStorageInstance.secureStorage.read(key: 'encryptionKey');

    if (containsEncryptionKey == null) {
      var key = Hive.generateSecureKey();
      await getSecureStorageInstance.secureStorage
          .write(key: 'encryptionKey', value: base64Encode(key));
    }
  }
}
