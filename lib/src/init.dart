import 'package:hive/hive.dart';
import 'package:quick_cache_flutter/src/encryption/get_encrypt_key_repo_impl.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';
import 'package:quick_cache_flutter/src/model/global_cache_setting_params.dart';
import 'package:quick_cache_flutter/src/utils/active_cleaning.dart';
import 'package:quick_cache_flutter/src/utils/lfu_removal.dart';
import 'package:quick_cache_flutter/src/utils/quick_cache_repo_impl.dart';

class QuickCacheFlutter extends QuickCacheRepoImpl {
  QuickCacheFlutter._(GlobalCacheSettingParams globalCacheSettingParams)
      : super(globalCacheSettingParams: globalCacheSettingParams);

  static late QuickCacheFlutter _instance;

  static QuickCacheFlutter get instance {
    return _instance;
  }

  static Future<void> init(
      {GlobalCacheSettingParams? globalCacheSettingParams}) async {
    _instance = QuickCacheFlutter._(
        globalCacheSettingParams ?? GlobalCacheSettingParams());
    await GetEncryptKeyRepoImpl.instance.storeCypher();
    (Box, Box) boxes = await GlobalBox.instance.getGlobalBox();
    if (globalCacheSettingParams != null &&
        globalCacheSettingParams.activeCleaning) {
      await ActiveCleaning.I.startActiveCleaning();
      if (globalCacheSettingParams.maxCacheSize != null) {
        LFURemoval.startLFUCleaning(globalCacheSettingParams, boxes);
      }
    }
  }
}
