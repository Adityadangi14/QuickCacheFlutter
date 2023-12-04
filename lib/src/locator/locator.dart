part of 'locator_import.dart';

GetIt getIt = GetIt.instance;

void setup() {
  //Get encryption box

  getIt.registerSingleton<GetEncryptKeyRepo>(GetEncryptKeyRepoImpl());

  // read write cache

  getIt.registerSingleton<QuickCacheRepo>(QuickCacheRepoImpl());
}
