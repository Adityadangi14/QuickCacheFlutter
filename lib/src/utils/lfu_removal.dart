import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/quick_cache_flutter.dart';

class LFURemoval {
  static void incAccessCount(Box box, String key) async {
    int count = 0;
    int? value = box.get(key);

    if (value == null) {
      await box.put(key, count + 1);
      return;
    }
    await box.put(key, value + 1);
  }

  static void deleteAccCount(Box accCountBox, String key) {
    bool isExist = accCountBox.containsKey(key);

    if (isExist) {
      accCountBox.delete(key);
    }
  }

  static Future<void> startLFUCleaning(
      GlobalCacheSettingParams globalCacheSettingParams,
      (Box, Box) allBoxes) async {
    int cacheSize = getCacheSizeInBytes(allBoxes);

    log(cacheSize.toString(), name: "cacheSize");

    if (globalCacheSettingParams.maxCacheSize != null &&
        cacheSize > globalCacheSettingParams.maxCacheSize!) {
      String key = getLeastUsedKey(allBoxes.$2);

      await allBoxes.$1.delete(key);
      await allBoxes.$2.delete(key);
    }
  }

  static String getLeastUsedKey(Box accCountBox) {
    Map countBoxMap = accCountBox.toMap();

    int count = 1;

    String keyToDelete = "";

    countBoxMap.forEach((key, value) {
      if (value <= count) {
        count = value;
        keyToDelete = key;
      }
    });

    return keyToDelete;
  }

  static int getCacheSizeInBytes((Box, Box) allBoxes) {
    Box globalBox = allBoxes.$1;
    Box accessCountBox = allBoxes.$2;

    String encodedGlobalBox = parseMap(globalBox.toMap());
    String encodedaccessCountBox = jsonEncode(accessCountBox.toMap());

    return utf8.encode(encodedGlobalBox).length +
        utf8.encode(encodedaccessCountBox).length;
  }

  static String parseMap(Map map) {
    Map newMap = {};

    map.forEach((key, value) {
      Map valueMap = {};

      if (value is Map) {
        value.forEach((key, value) {
          if (value is DateTime) {
            valueMap.putIfAbsent(key, () => value.toIso8601String());
          } else {
            valueMap.putIfAbsent(key, () => value);
          }
        });
      }
      newMap.putIfAbsent(key, () => valueMap);
    });

    log(newMap.toString(), name: "newmap");

    return jsonEncode(newMap);
  }
}
