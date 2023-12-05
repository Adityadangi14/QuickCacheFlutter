part of 'locator_import.dart';

GetIt getIt = GetIt.instance;

void setup() {
  // global box

  getIt.registerSingleton(GlobalBox());

  // Secure instance

  getIt.registerSingleton(GetSecureStorageInstance());

  //Get encryption box

  getIt.registerSingleton<GetEncryptKeyRepo>(GetEncryptKeyRepoImpl());

  // read write cache

  getIt.registerSingleton<QuickCacheRepo>(QuickCacheRepoImpl());
}
