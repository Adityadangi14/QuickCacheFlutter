import 'package:quick_cache_flutter/src/encryption/get_encryt_key_repo.dart';
import 'package:quick_cache_flutter/src/global_box/global_box.dart';
import 'package:quick_cache_flutter/src/locator/locator_import.dart';
import 'package:quick_cache_flutter/src/read_write/quick_cache_repo_impl.dart';

class QuickCacheFlutter extends QuickCacheRepoImpl {
  QuickCacheFlutter._();

  static final instance = QuickCacheFlutter._();

  QuickCacheFlutter() {
    setup();
  }

  void init() {
    getIt<GetEncryptKeyRepo>().storeCypher();
    globalBox.getGlobalBox();
  }
}
