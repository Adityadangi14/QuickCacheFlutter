import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetSecureStorageInstance {
  // GetSecureStorageInstance._();
  // static final instance = GetSecureStorageInstance._();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
}
