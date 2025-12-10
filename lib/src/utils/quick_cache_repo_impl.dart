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

  final Map<String, dynamic> _memoryCache = {};

  @override
  Future<dynamic> readCache({required String key}) async {
    try {
      final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
      final Box encryptedBox = box.$1;
      final Box accessCountBox = box.$2;

      final memoryValue = _memoryCache[key];

      if (memoryValue != null) {
        final DateTime? expiry = memoryValue['expiryDuration'] as DateTime?;
        final DateTime settingDateTime =
            memoryValue['currentDateTime'] as DateTime;
        if (expiry != null && expiry.isBefore(DateTime.now())) {
          _memoryCache.remove(key);
          encryptedBox.delete(key);
          LFURemoval.deleteAccCount(accessCountBox, key);
          return null;
        }

        final Duration? globalDuration =
            globalCacheSettingParams?.globalExpiryDuration;

        if (globalDuration != null) {
          final globalExpiry = settingDateTime.add(globalDuration);

          if (globalExpiry.isBefore(DateTime.now())) {
            _memoryCache.remove(key);
            encryptedBox.delete(key);
            LFURemoval.deleteAccCount(accessCountBox, key);
            return null;
          }
        }

        LFURemoval.incAccessCount(accessCountBox, key);
        return jsonDecode(memoryValue["value"]);
      }

      final Map<dynamic, dynamic>? value =
          encryptedBox.get(key) as Map<dynamic, dynamic>?;

      if (value == null) return null;

      final DateTime? expiry = value['expiryDuration'] as DateTime?;
      final DateTime settingDateTime = value['currentDateTime'] as DateTime;

      if (expiry != null && expiry.isBefore(DateTime.now())) {
        encryptedBox.delete(key);
        LFURemoval.deleteAccCount(accessCountBox, key);
        return null;
      }

      final Duration? globalDuration =
          globalCacheSettingParams?.globalExpiryDuration;

      if (globalDuration != null) {
        final globalExpiry = settingDateTime.add(globalDuration);

        if (globalExpiry.isBefore(DateTime.now())) {
          encryptedBox.delete(key);
          LFURemoval.deleteAccCount(accessCountBox, key);
          return null;
        }
      }

      _memoryCache[key] = value;

      LFURemoval.incAccessCount(accessCountBox, key);

      return jsonDecode(value["value"]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setCache({
    required String key,
    required dynamic value,
    Duration? expiryDuration,
  }) async {
    try {
      final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
      final Box encryptedBox = box.$1;
      final Box accessCountBox = box.$2;

      final DateTime now = DateTime.now();

      final Map<String, dynamic> cachePayload = {
        "value": json.encode(value),
        "expiryDuration":
            expiryDuration != null ? now.add(expiryDuration) : null,
        "currentDateTime": now,
      };

      await encryptedBox.put(key, cachePayload);

      _memoryCache[key] = cachePayload;

      LFURemoval.incAccessCount(accessCountBox, key);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void removeAllCache() async {
    final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
    Box encryptedBox = box.$1;

    encryptedBox.clear();
    _memoryCache.clear();
  }

  @override
  void deleteValue({required key}) async {
    final (Box, Box) box = await GlobalBox.instance.getGlobalBox();
    Box encryptedBox = box.$1;

    encryptedBox.delete(key);
    _memoryCache.remove(key);
    LFURemoval.deleteAccCount(box.$2, key);
  }
}
