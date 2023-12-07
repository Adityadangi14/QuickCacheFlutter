import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_cache_flutter/src/get_secure_storage_instance.dart';

mixin class GlobalBox {
  GetSecureStorageInstance getSecureStorageInstance =
      GetSecureStorageInstance.instance;

  Future<Box> getGlobalBox() async {
    Directory dir = await getTemporaryDirectory();
    Hive.init(dir.path);
    var encryptionKey = base64Url.decode(await getSecureStorageInstance
            .secureStorage
            .read(key: 'encryptionKey') ??
        '');

    return Hive.openBox('global_box',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }
}
