import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';

import 'package:quick_cache_flutter/src/read_write/quick_cache_repo.dart';

class QuickCacheRepoImpl implements QuickCacheRepo {
  @override
  dynamic readCache({required key}) async {
    try {
      Box encryptedBox = await GlobalBox.instance.getGlobalBox();

      Map? value = encryptedBox.get(key);

      if (value != null) {
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
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setCache(
      {required key, required value, Duration? expiryDuration}) async {
    try {
      Box encryptedBox = await GlobalBox.instance.getGlobalBox();

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

  @override
  void removeAllCache() async {
    Box encryptedBox = await GlobalBox.instance.getGlobalBox();

    encryptedBox.clear();
  }

  @override
  void deleteValue({required key}) async {
    Box encryptedBox = await GlobalBox.instance.getGlobalBox();

    encryptedBox.delete(key);
  }
}
