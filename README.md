
## 🚀 Quick Cache Flutter 

Manage your cache  securely with a single line of code , without sacrificing performance.
## Features

⚡ Fast - uses [Hive](https://pub.dev/packages/hive) underneath for peak performance.

🔒 Secure - Encrypts everything you save.

⏲️ Expiry Duration - You can provide stale period to each key.

😉 Easy to use - Single line ``read`` ``write``.

## Getting started

You have to initalized ```QuickCaheFlutter``` before runApp(Widget) (Call it after WidgetsFlutterBinding.ensureInitialized()):

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuickCacheFlutter.instance.init();
  runApp(const MyApp());
}
```

## Usage

📖 ``QuickCacheFlutter.instance.readCache`` - Reads the value for given key

✍️ ``QuickCacheFlutter.instance.setCache`` - Save a sigle key value in database.

🧹 ``QuickCacheFlutter.instance.removeAllCache`` - Clear all cache from database.

🗑️ ``QuickCacheFlutter.instance.deleteValue`` -Deletes a sigle value.

if ``expiryDuration`` is not provided or set to ``null`` then the value will persist for app lifetime or till it is manually deleted.

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

👉 [X](https://twitter.com/_aditya01010101)