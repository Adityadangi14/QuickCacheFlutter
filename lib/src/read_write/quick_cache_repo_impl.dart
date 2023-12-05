import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';
import 'package:quick_cache_flutter/src/locator/locator_import.dart';
import 'package:quick_cache_flutter/src/read_write/quick_cache_repo.dart';

class QuickCacheRepoImpl implements QuickCacheRepo {
  GlobalBox globalBox = getIt<GlobalBox>();

  QuickCacheRepoImpl() {
    setup();
  }
  @override
  dynamic readCache({required key}) async {
    try {
      Box encryptedBox = await globalBox.getGlobalBox();

      Map value = encryptedBox.get(key);

      if (value['expiryDuration'] != null) {
        if (DateTime.now().isAfter(value["expiryDuration"])) {
          encryptedBox.delete(key);
          return null;
        } else {
          return value['value'];
        }
      } else {
        return value['value'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setCache(
      {required key, required value, Duration? expiryDuration}) async {
    try {
      Box encryptedBox = await globalBox.getGlobalBox();

      encryptedBox.put(key, {
        "value": value,
        "expiryDuration":
            expiryDuration != null ? DateTime.now().add(expiryDuration) : null,
        "currentDateTime": DateTime.now()
      });
    } catch (e) {
      rethrow;
    }
  }
}
