import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cache_flutter/quick_cache_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final Map<String, String> mockStorage = {};

  const MethodChannel pathProviderChannel =
      MethodChannel('plugins.flutter.io/path_provider');

  setUp(() {
    mockStorage.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
      if (call.method == 'read') {
        return mockStorage[call.arguments['key']];
      }
      if (call.method == 'write') {
        mockStorage[call.arguments['key']] = call.arguments['value'];
        return null;
      }
      if (call.method == 'delete') {
        mockStorage.remove(call.arguments['key']);
        return null;
      }
      if (call.method == 'containsKey') {
        return mockStorage.containsKey(call.arguments['key']);
      }
      return null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') {
        return Directory.systemTemp.createTempSync().path;
      }
      return null;
    });
  });

  test('QuickCache initializes correctly', () async {
    await QuickCacheFlutter.init();

    final cache = QuickCacheFlutter.instance;

    cache.setCache(key: "test", value: "test123");
    final value = await cache.readCache(key: "test");

    print(value);

    expect(cache, isNotNull);
  });
}
