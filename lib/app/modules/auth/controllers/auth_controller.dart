import 'package:get/get.dart';

import '../../../data/storage/local_storage_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  late final LocalStorageService _storage;

  final RxBool _isFirstTime = true.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxString _userName = ''.obs;
  final RxString _userEmail = ''.obs;

  bool get isFirstTime => _isFirstTime.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<LocalStorageService>();
    _loadInitialState();
  }

  void _loadInitialState() {
    _isFirstTime.value = _storage.getIsFirstTime();
    _isLoggedIn.value = _storage.getIsLoggedIn();
    _userName.value = _storage.getUserName();
    _userEmail.value = _storage.getUserEmail();
  }

  Future<void> setFirstTimeDone() async {
    _isFirstTime.value = false;
    await _storage.setFirstTimeDone();
  }

  Future<void> login({String? name, String? email}) async {
    _isLoggedIn.value = true;
    await _storage.setLoggedIn(true);
    if (name != null) {
      _userName.value = name;
      await _storage.setUserName(name);
    }
    if (email != null) {
      _userEmail.value = email;
      await _storage.setUserEmail(email);
    }
  }

  Future<void> logout() async {
    _isLoggedIn.value = false;
    await _storage.clearAuthData();
  }

  /// Vérifie que l'utilisateur est connecté avant de poursuivre une action.
  /// Renvoie `true` si connecté, sinon ouvre l'écran de connexion et renvoie
  /// `true` uniquement si la connexion est réussie.
  Future<bool> ensureLoggedIn() async {
    if (isLoggedIn) return true;

    await Get.toNamed(Routes.LOGIN);
    // Après retour de l'écran de connexion, on relit l'état
    return isLoggedIn;
  }
}
