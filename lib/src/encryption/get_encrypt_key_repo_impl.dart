import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/encryption/get_encryt_key_repo.dart';
import 'package:quick_cache_flutter/src/get_secure_storage_instance.dart';
import 'package:quick_cache_flutter/src/locator/locator_import.dart';

class GetEncryptKeyRepoImpl implements GetEncryptKeyRepo {
  GetSecureStorageInstance getSecureStorageInstance =
      getIt<GetSecureStorageInstance>();
  @override
  void storeCypher() async {
    var containsEncryptionKey =
        await getSecureStorageInstance.secureStorage.read(key: 'encryptionKey');

    if (containsEncryptionKey == null) {
      var key = Hive.generateSecureKey();
      await getSecureStorageInstance.secureStorage
          .write(key: 'encryptionKey', value: base64Encode(key));
    }
  }
}
