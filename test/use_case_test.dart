import 'package:f_local_auth_hive_template/data/repositories/auth_repo.dart';
import 'package:f_local_auth_hive_template/domain/entities/user.dart';
import 'package:f_local_auth_hive_template/domain/repositories/i_auth_repo.dart';
import 'package:f_local_auth_hive_template/domain/use_case/auth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class FakeRepository extends Fake implements AuthRepo {
  bool logged = false;

  @override
  Future<bool> isLogged() async {
    return logged;
  }

  @override
  Future<void> setLoggedIn() async {
    logged = true;
  }

  @override
  Future<void> logout() async {
    logged = false;
  }

  @override
  Future<void> signup(email, password) async {
    return;
  }

  @override
  Future<User> getUserFromEmail(email) async {
    if (email == 'a@a.com') {
      return User(email: email, password: "123");
    } else {
      throw "User not found";
    }
  }
}

void main() {
  group('AuthenticationUseCase', () {
    late AuthUseCase authUseCase;

    setUp(() {
      Get.put<IAuthRepo>(FakeRepository());
      authUseCase = AuthUseCase(Get.find());
    });

    test('init should return false', () async {
      expect(await authUseCase.init, false);
    });

    test('login test', () async {
      expect(
        () async => await authUseCase.login('b@b.com', '123456'),
        throwsA("User not found"),
      );

      expect(
        () async => await authUseCase.login('a@a.com', '1234'),
        throwsA("Incorrect password"),
      );

      await authUseCase.login('a@a.com', '123');
      expect(await authUseCase.init, true);
    });
  });
}
