class GlobalCacheSettingParams {
  final bool activeCleaning;
  final Duration? globalExpiryDuration;
  final int? maxCacheSize;

  GlobalCacheSettingParams(
      {this.globalExpiryDuration,
      this.maxCacheSize,
      this.activeCleaning = false});
}
