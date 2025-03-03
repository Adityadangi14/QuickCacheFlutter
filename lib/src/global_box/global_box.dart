import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_cache_flutter/src/get_secure_storage_instance.dart';

class GlobalBox {
  GlobalBox._();

  static final instance = GlobalBox._();

  GetSecureStorageInstance getSecureStorageInstance =
      GetSecureStorageInstance.instance;

  Future<(Box, Box)> getGlobalBox() async {
    Directory dir = await getTemporaryDirectory();
    Hive.init(dir.path);
    var encryptionKey = base64Url.decode(await getSecureStorageInstance
            .secureStorage
            .read(key: 'encryptionKey') ??
        '');

    assert(encryptionKey != [],
        "No encryption key found, make sure cache is properly initlized");

    Box globalBox = await Hive.openBox('global_box',
        encryptionCipher: HiveAesCipher(encryptionKey));

    Box accessCountBox = await Hive.openBox('access_count_box',
        encryptionCipher: HiveAesCipher(encryptionKey));

    return (globalBox, accessCountBox);
  }
}
