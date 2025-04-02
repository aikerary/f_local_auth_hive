import 'package:get/get.dart';
import '../../domain/use_case/auth_use_case.dart';

class AuthController extends GetxController {
  final _logged = false.obs;
  final AuthUseCase _authentication;

  void initializeRoute() async {
    logged = await _authentication.init;
  }

  AuthController(this._authentication) {
    initializeRoute();
  }

  bool get logged => _logged.value;

  set logged(bool mode) {
    _logged.value = mode;
  }

  Future<void> login(user, password) async {
    await _authentication.login(user, password);
    _logged.value = true;
  }

  Future<void> signup(user, password) async {
    await _authentication.signup(user, password);
  }

  Future<void> logout() async {
    await _authentication.logout();
    _logged.value = false;
  }
}
