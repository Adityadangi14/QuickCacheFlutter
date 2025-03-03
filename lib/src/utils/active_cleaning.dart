import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';

class ActiveCleaning {
  ActiveCleaning._();

  static final I = ActiveCleaning._();

  Future<void> startActiveCleaning() async {
    final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
    Box encryptedBox = box.$1;

    Map data = encryptedBox.toMap();

    List<String> keysToDelete =
        await compute(_runCleaning, data) as List<String>;

    encryptedBox.deleteAll(keysToDelete);
  }

  Future<dynamic> _runCleaning(Map data) async {
    List<String> keys = [];

    data.forEach((key, value) {
      final expiry = value['expiryDuration'] as DateTime?;

      if (expiry != null && expiry.isBefore(DateTime.now())) {
        keys.add(key);
      }
    });

    return keys;
  }
}
