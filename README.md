## 🚀 Quick Cache Flutter 

📢 **Breaking Changes**
```
The method QuickCacheFlutter.instance.init is deprecated. 
Use QuickCacheFlutter.init instead.
```

## Features

Manage your cache securely with a single line of code, without sacrificing performance.

⚡ Fast - uses [Hive](https://pub.dev/packages/hive) underneath for peak performance.

🔒 Secure - Encrypts everything you save.

⏲️ Expiry Duration - You can provide a stale period for each key.

😉 Easy to use - Single line ``read`` ``write``.

🧹 Active and passive cleaning - Automatically removes expired cache entries in the background while allowing manual cleanup when needed.

⏳ Global Expiry Duration - Set a default expiration time for all cache entries, ensuring automatic cleanup without needing to specify expiry for each key.

## Getting started

You have to initialize ```QuickCacheFlutter``` before runApp(Widget) (Call it after WidgetsFlutterBinding.ensureInitialized()):

```
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  QuickCacheFlutter.init(
      globalCacheSettingParams: GlobalCacheSettingParams(
          activeCleaning: true,
          globalExpiryDuration: const Duration(minutes: 5),
          maxCacheSize: 5000)); // maxCacheSize is in bytes.
  runApp(const MyApp());
}
```
## GlobalCacheSettingParams

This version introduces ``GlobalCacheSettingParams``, which aims to provide an easy way to manage settings while initializing cache.

🧼 ``activeCleaning`` - When set to `true`, expired cache entries are automatically cleaned up in the background to free up space and maintain performance.

⏳ ``globalExpiryDuration`` - Defines a default expiration time for all cache entries. If no expiry is specified for an individual key, this duration will be used instead. if ``globalExpiryDuration`` is not specified and ``expiryDuration`` is also not specified then key will remain in memory until it is manually deleted or cleaned if ``maxCacheSize`` exceeds.

📦 ``maxCacheSize`` - Sets the maximum allowable cache size (in bytes). Once this limit is reached, older cache entries will be removed to make space for new ones by using LFU policy.

## Usage

📖 ``QuickCacheFlutter.instance.readCache`` - Reads the value for given key

✍️ ``QuickCacheFlutter.instance.setCache`` - Save a single key value in database.

🧹 ``QuickCacheFlutter.instance.removeAllCache`` - Clear all cache from database.

🗑️ ``QuickCacheFlutter.instance.deleteValue`` -Deletes a single value.

If ``expiryDuration`` is not provided or set to ``null`` then the value will persist for app lifetime or till it is manually deleted.

```
QuickCacheFlutter.instance.setCache(
                    key: 'key',
                    value: value,
                    expiryDuration: const Duration(seconds: 20));
```

## Additional information

Feedbacks, issues, contributions and suggestions are more than welcomed! 😁

## Connect with me

👉 [LinkedIn](https://www.linkedin.com/in/aditya-dangi-b70604155/)

👉 [X (twitter)](https://twitter.com/_aditya01010101)

