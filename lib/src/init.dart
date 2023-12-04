import 'package:quick_cache_flutter/src/encryption/get_encrypt_key_repo_impl.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';
import 'package:quick_cache_flutter/src/locator/locator_import.dart';
import 'package:quick_cache_flutter/src/read_write/quick_cache_repo_impl.dart';

class QuickCacheFlutter extends QuickCacheRepoImpl {
  QuickCacheFlutter._();

  static final instance = QuickCacheFlutter._();

  GetEncryptKeyRepoImpl getEncryptKeyRepoImpl = GetEncryptKeyRepoImpl();

  void init() {
    setup();
    getEncryptKeyRepoImpl.storeCypher();
    GlobalBox.instance.getGlobalBox();
  }
}
