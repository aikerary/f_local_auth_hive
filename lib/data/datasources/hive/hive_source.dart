import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/user.dart';
import '../../models/user_db.dart';
import '../i_local_auth_source.dart';
import '../shared_prefs/local_preferences.dart';

class HiveSource implements ILocalAuthSource {
  final _sharedPreferences = LocalPreferences();
  final String _userBox = 'userDb';

  Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<String> getLoggedUser() async {
    // Implement getLoggedUser with shared preferences
    return await _sharedPreferences.retrieveData<String>('user') ?? '';
  }

  @override
  Future<User> getUserFromEmail(email) async {
    // Implement getUserFromEmail with HIVE
    logInfo("Getting user with email $email");
    final box = Hive.box(_userBox);
    final UserDb? userDb = box.get(email);

    if (userDb != null) {
      logInfo("User found");
      return User(email: userDb.email, password: userDb.password);
    } else {
      logError("User not found");
      throw "User not found";
    }
  }

  @override
  Future<bool> isLogged() async {
    // Implement isLogged with shared preferences
    return await _sharedPreferences.retrieveData<bool>('logged') ?? false;
  }

  @override
  Future<void> logout() async {
    // Implement logout with shared preferences
    await _sharedPreferences.storeData('logged', false);
  }

  @override
  Future<void> setLoggedIn() async {
    // Implement setLoggedIn with shared preferences
    await _sharedPreferences.storeData('logged', true);
  }

  @override
  Future<void> signup(email, password) async {
    // Implement signup with HIVE
    logInfo("Signing up user with email $email");
    final box = Hive.box(_userBox);
    final user = UserDb(email: email, password: password);

    await box.put(email, user);
    await _sharedPreferences.storeData('user', email);
    await _sharedPreferences.storeData('password', password);

    logInfo("User registered");
  }
}
