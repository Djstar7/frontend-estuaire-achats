import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Centralise toutes les lectures/écritures locales de l'application
/// (token d'auth, infos utilisateur, flags d'onboarding, etc.).
class StorageKeys {
  StorageKeys._();

  static const String authToken = 'auth_token';
  static const String isFirstTime = 'isFirstTime';
  static const String isLoggedIn = 'isLoggedIn';
  static const String userName = 'userName';
  static const String userEmail = 'userEmail';
}

class LocalStorageService extends GetxService {
  late final GetStorage _storage;

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
  }

  T? read<T>(String key) => _storage.read<T>(key);

  Future<void> write<T>(String key, T value) => _storage.write(key, value);

  Future<void> remove(String key) => _storage.remove(key);

  Future<void> clear() => _storage.erase();

  // --- Helpers Auth / Onboarding ---

  String? getAuthToken() => read<String>(StorageKeys.authToken);

  Future<void> saveAuthToken(String token) =>
      write<String>(StorageKeys.authToken, token);

  Future<void> clearAuthToken() => remove(StorageKeys.authToken);

  bool getIsFirstTime() =>
      read<bool>(StorageKeys.isFirstTime) ?? true;

  Future<void> setFirstTimeDone() =>
      write<bool>(StorageKeys.isFirstTime, false);

  bool getIsLoggedIn() =>
      read<bool>(StorageKeys.isLoggedIn) ?? false;

  Future<void> setLoggedIn(bool value) =>
      write<bool>(StorageKeys.isLoggedIn, value);

  String getUserName() =>
      read<String>(StorageKeys.userName) ?? '';

  Future<void> setUserName(String name) =>
      write<String>(StorageKeys.userName, name);

  String getUserEmail() =>
      read<String>(StorageKeys.userEmail) ?? '';

  Future<void> setUserEmail(String email) =>
      write<String>(StorageKeys.userEmail, email);

  /// Nettoie toutes les infos liées à l'authentification.
  Future<void> clearAuthData() async {
    await clearAuthToken();
    await setLoggedIn(false);
    await write<String>(StorageKeys.userName, '');
    await write<String>(StorageKeys.userEmail, '');
  }
}

