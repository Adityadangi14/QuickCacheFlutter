abstract class QuickCacheRepo {
  void setCache(
      {required dynamic key, required dynamic value, Duration? expiryDuration});
  dynamic readCache({required dynamic key});
  void removeAllCache();
  void deleteValue({required dynamic key});
}
