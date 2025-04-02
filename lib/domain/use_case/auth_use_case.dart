import '../entities/user.dart';
import '../repositories/i_auth_repo.dart';

class AuthUseCase {
  final IAuthRepo _authenticationRepo;

  AuthUseCase(this._authenticationRepo);

  Future<bool> get init async => await _authenticationRepo.isLogged();

  Future<void> login(email, password) async {
    try {
      User user = await _authenticationRepo.getUserFromEmail(email);
      if (user.password != password) {
        throw "Incorrect password";
      }
    } catch (e) {
      // If it was already a known error, rethrow it
      if (e == "Incorrect password") {
        rethrow;
      }

      throw "User not found";
    }
    await _authenticationRepo.setLoggedIn();
  }

  Future<void> signup(email, password) async {
    return await _authenticationRepo.signup(email, password);
  }

  Future<void> logout() async {
    await _authenticationRepo.logout();
  }
}
