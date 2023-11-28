import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';
import 'package:quick_cache_flutter/src/read_write/quick_cache_repo.dart';

class QuickCacheRepoImpl implements QuickCacheRepo {
  @override
  dynamic readCache({required key}) async {
    try {
      Box encryptedBox = await GlobalBox.instance.getGlobalBox();

      Map value = encryptedBox.get(key);

      if (value['expiryDuration'] != null) {
        if (DateTime.now().isAfter(value["expiryDuration"])) {
          return null;
        } else {
          return value['value'];
        }
      } else {
        return value['value'];
      }
    } catch (e) {
      throw (e);
    }
  }

  @override
  void setCache(
      {required key, required value, Duration? expiryDuration}) async {
    try {
      Box encryptedBox = await GlobalBox.instance.getGlobalBox();

      encryptedBox.put(key, {
        "value": value,
        "expiryDuration":
            expiryDuration != null ? DateTime.now().add(expiryDuration) : null,
        "currentDateTime": DateTime.now()
      });
    } catch (e) {
      throw (e);
    }
  }
}
