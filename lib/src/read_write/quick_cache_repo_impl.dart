import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';

import 'package:quick_cache_flutter/src/read_write/quick_cache_repo.dart';

class QuickCacheRepoImpl with GlobalBox implements QuickCacheRepo {
  @override
  dynamic readCache({required key}) async {
    try {
      Box encryptedBox = await getGlobalBox();

      Map value = encryptedBox.get(key);

      if (value['expiryDuration'] != null) {
        if (DateTime.now().isAfter(value["expiryDuration"])) {
          encryptedBox.delete(key);
          return null;
        } else {
          return json.decode(value['value']);
        }
      } else {
        return json.decode(value['value']);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setCache(
      {required key, required value, Duration? expiryDuration}) async {
    try {
      Box encryptedBox = await getGlobalBox();

      encryptedBox.put(key, {
        "value": json.encode(value),
        "expiryDuration":
            expiryDuration != null ? DateTime.now().add(expiryDuration) : null,
        "currentDateTime": DateTime.now()
      });
    } catch (e) {
      rethrow;
    }
  }
}
