import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:quick_cache_flutter/src/global_box/global_box.dart';
import 'package:quick_cache_flutter/src/model/global_cache_setting_params.dart';
import 'package:quick_cache_flutter/src/utils/lfu_removal.dart';
import 'package:quick_cache_flutter/src/utils/quick_cache_repo.dart';

class QuickCacheRepoImpl implements QuickCacheRepo {
  GlobalCacheSettingParams? globalCacheSettingParams;
  QuickCacheRepoImpl({
    required this.globalCacheSettingParams,
  });

  @override
  Future<dynamic> readCache({required String key}) async {
    try {
      final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
      Box encryptedBox = box.$1;
      final Map<dynamic, dynamic>? value = encryptedBox.get(key);

      if (value == null) return null;

      final expiry = value['expiryDuration'] as DateTime?;

      if (expiry == null) return value["value"];

      if (expiry.isBefore(DateTime.now())) {
        encryptedBox.delete(key);
        LFURemoval.deleteAccCount(box.$2, key);
        return null;
      }

      final Duration? globalDuration =
          globalCacheSettingParams?.globalExpiryDuration;

      final settingDateTime = value["currentDateTime"] as DateTime;

      if (globalDuration != null) {
        final globalExpieryTime = settingDateTime.add(globalDuration);

        if (globalExpieryTime.isBefore(DateTime.now())) {
          encryptedBox.delete(key);
          LFURemoval.deleteAccCount(box.$2, key);

          return null;
        }
      }

      LFURemoval.incAccessCount(box.$2, key);

      var val = jsonDecode(value["value"]);

      return val;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setCache(
      {required key, required value, Duration? expiryDuration}) async {
    try {
      final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
      Box encryptedBox = box.$1;

      await encryptedBox.put(key, {
        "value": json.encode(value),
        "expiryDuration":
            expiryDuration != null ? DateTime.now().add(expiryDuration) : null,
        "currentDateTime": DateTime.now(),
      });

      LFURemoval.incAccessCount(box.$2, key);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void removeAllCache() async {
    final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
    Box encryptedBox = box.$1;

    encryptedBox.clear();
  }

  @override
  void deleteValue({required key}) async {
    final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
    Box encryptedBox = box.$1;

    encryptedBox.delete(key);
    LFURemoval.deleteAccCount(box.$2, key);
  }
}
