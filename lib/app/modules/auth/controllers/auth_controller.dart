import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final _storage = GetStorage();

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
    _loadInitialState();
  }

  void _loadInitialState() {
    _isFirstTime.value = _storage.read<bool>('isFirstTime') ?? true;
    _isLoggedIn.value = _storage.read<bool>('isLoggedIn') ?? false;
    _userName.value = _storage.read<String>('userName') ?? '';
    _userEmail.value = _storage.read<String>('userEmail') ?? '';
  }

  void setFirstTimeDone() {
    _isFirstTime.value = false;
    _storage.write('isFirstTime', false);
  }

  void login({String? name, String? email}) {
    _isLoggedIn.value = true;
    _storage.write('isLoggedIn', true);
    if (name != null) {
      _userName.value = name;
      _storage.write('userName', name);
    }
    if (email != null) {
      _userEmail.value = email;
      _storage.write('userEmail', email);
    }
  }

  void logout() {
    _isLoggedIn.value = false;
    _storage.write('isLoggedIn', false);
  }
}
