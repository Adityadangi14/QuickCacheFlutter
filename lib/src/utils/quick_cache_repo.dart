abstract class QuickCacheRepo {
  void setCache(
      {required dynamic key, required dynamic value, Duration? expiryDuration});
  Future<dynamic> readCache({required String key});
  void removeAllCache();
  void deleteValue({required dynamic key});
}
