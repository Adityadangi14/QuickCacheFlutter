
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

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
