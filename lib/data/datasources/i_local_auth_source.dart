import '../../domain/entities/user.dart';

abstract class ILocalAuthSource {
  Future<void> signup(email, password);
  Future<void> logout();
  Future<bool> isLogged();
  Future<String> getLoggedUser();
  Future<User> getUserFromEmail(email);
  Future<void> setLoggedIn();
}
