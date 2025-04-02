import '../entities/user.dart';

abstract class IAuthRepo {
  Future<User> getUserFromEmail(email);
  Future<void> signup(email, password);
  Future<void> logout();
  Future<bool> isLogged();
  Future<String> getLoggedUser();
  Future<void> setLoggedIn();
}
