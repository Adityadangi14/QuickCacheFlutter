abstract class QuickCacheRepo {
  Future<void> setCache(
      {required String key, required dynamic value, Duration? expiryDuration});
  Future<dynamic> readCache({required String key});
  void removeAllCache();
  void deleteValue({required dynamic key});
}
