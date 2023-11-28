import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_cache_flutter/src/get_secure_storage_instance.dart';

class GlobalBox {
  GlobalBox._();

  static final instance = GlobalBox._();

  Future<Box> getGlobalBox() async {
    Directory dir = await getTemporaryDirectory();
    Hive.init(dir.path);
    var encryptionKey = base64Url.decode(await GetSecureStorageInstance
            .instance.secureStorage
            .read(key: 'encryptionKey') ??
        '');

    return Hive.openBox('global_box',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }
}
