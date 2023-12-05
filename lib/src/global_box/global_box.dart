import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_cache_flutter/src/get_secure_storage_instance.dart';
import 'package:quick_cache_flutter/src/locator/locator_import.dart';

class GlobalBox {
  GetSecureStorageInstance getSecureStorageInstance =
      getIt<GetSecureStorageInstance>();

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
