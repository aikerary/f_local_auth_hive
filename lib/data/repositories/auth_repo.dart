import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repo.dart';
import '../datasources/i_local_auth_source.dart';

class AuthRepo implements IAuthRepo {
  final ILocalAuthSource localAuthSource;

  AuthRepo(this.localAuthSource);

  @override
  Future<User> getUserFromEmail(email) async {
    return localAuthSource.getUserFromEmail(email);
  }

  @override
  Future<void> logout() async {
    return localAuthSource.logout();
  }

  @override
  Future<void> signup(email, password) async {
    return localAuthSource.signup(email, password);
  }

  @override
  Future<String> getLoggedUser() async {
    return localAuthSource.getLoggedUser();
  }

  @override
  Future<bool> isLogged() async {
    return localAuthSource.isLogged();
  }

  @override
  Future<void> setLoggedIn() async {
    return localAuthSource.setLoggedIn();
  }
}
