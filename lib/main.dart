import 'package:f_local_auth_hive_template/data/datasources/hive/hive_source.dart';
import 'package:f_local_auth_hive_template/data/datasources/shared_prefs/shared_pref_local_auth_source.dart';
import 'package:f_local_auth_hive_template/data/models/user_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'data/datasources/i_local_auth_source.dart';
import 'data/repositories/auth_repo.dart';
import 'domain/repositories/i_auth_repo.dart';
import 'domain/use_case/auth_use_case.dart';
import 'ui/controllers/auth_controller.dart';
import 'ui/my_app.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> _openBox() async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.initFlutter();
  Hive.registerAdapter(UserDbAdapter());
  await Hive.openBox('userDb');
  logInfo("Box opened userDb ${await Hive.boxExists('userDb')}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Loggy.initLoggy(logPrinter: const PrettyPrinter(showColors: true));
  await _openBox();
  // Changed to use HiveSource instead of SharedPrefLocalAuthSource
  Get.put<ILocalAuthSource>(HiveSource());
  Get.put<IAuthRepo>(AuthRepo(Get.find()));
  Get.put(AuthUseCase(Get.find()));
  Get.put(AuthController(Get.find()));
  runApp(const MyApp());
}
