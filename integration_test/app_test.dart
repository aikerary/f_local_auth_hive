import 'package:f_local_auth_hive_template/data/datasources/hive/hive_source.dart';
import 'package:f_local_auth_hive_template/data/datasources/i_local_auth_source.dart';
import 'package:f_local_auth_hive_template/data/models/user_db.dart';
import 'package:f_local_auth_hive_template/data/repositories/auth_repo.dart';
import 'package:f_local_auth_hive_template/domain/repositories/i_auth_repo.dart';
import 'package:f_local_auth_hive_template/domain/use_case/auth_use_case.dart';
import 'package:f_local_auth_hive_template/ui/controllers/auth_controller.dart';
import 'package:f_local_auth_hive_template/ui/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Box>> _openBox() async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  List<Box> boxList = [];
  await Hive.initFlutter();
  Hive.registerAdapter(UserDbAdapter());
  boxList.add(await Hive.openBox('userDb'));
  Hive.box('userDb').clear(); // clear the box before each test
  logInfo("Box opened userDb ${await Hive.boxExists('userDb')}");
  return boxList;
}

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();
  Get.put<ILocalAuthSource>(HiveSource());
  Get.put<IAuthRepo>(AuthRepo(Get.find()));
  Get.put(AuthUseCase(Get.find()));
  Get.put(AuthController(Get.find()));
  return const MyApp();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Complete Authentication flow", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    //verify that we are in login page
    expect(find.byKey(const Key('loginScaffold')), findsOneWidget);

    expect(find.byKey(const Key('loginEmail')), findsNWidgets(1));

    // go to sign in
    await tester.tap(find.byKey(const Key('loginCreateUser')));

    await tester.pumpAndSettle();

    //verify that we are in signup page
    expect(find.byKey(const Key('signUpScaffold')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('signUpEmail')), 'a@a.com');

    await tester.enterText(find.byKey(const Key('signUpPassword')), '123456');

    await tester.tap(find.byKey(const Key('signUpSubmit')));

    await tester.pumpAndSettle();

    //verify that we are in login page
    expect(find.byKey(const Key('loginScaffold')), findsOneWidget);

    // go to sign in
    await tester.tap(find.byKey(const Key('loginCreateUser')));

    await tester.pumpAndSettle();

    //verify that we are in signup page
    expect(find.byKey(const Key('signUpScaffold')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('signUpEmail')), 'a2@a.com');

    await tester.enterText(find.byKey(const Key('signUpPassword')), '123456');

    await tester.tap(find.byKey(const Key('signUpSubmit')));

    await tester.pumpAndSettle();

    //verify that we are in login page
    expect(find.byKey(const Key('loginScaffold')), findsOneWidget);
    //login

    await tester.enterText(find.byKey(const Key('loginEmail')), 'b@b.com');

    await tester.enterText(find.byKey(const Key('loginPassword')), '123456');

    await tester.tap(find.byKey(const Key('loginSubmit')));

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('loginEmail')), 'a@a.com');

    await tester.enterText(find.byKey(const Key('loginPassword')), '123456');

    await tester.tap(find.byKey(const Key('loginSubmit')));

    await tester.pumpAndSettle();

    //verify that we are in content page
    expect(find.byKey(const Key('contentScaffold')), findsOneWidget);

    // go to profile page
    await tester.tap(find.byIcon(Icons.verified_user));
    await tester.pumpAndSettle();

    // logout
    await tester.tap(find.byKey(const Key('profileLogout')));
    await tester.pumpAndSettle();

    //verify that we are in login page
    expect(find.byKey(const Key('loginScaffold')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('loginEmail')), 'a2@a.com');

    await tester.enterText(find.byKey(const Key('loginPassword')), '123456');

    await tester.tap(find.byKey(const Key('loginSubmit')));

    await tester.pumpAndSettle();

    //verify that we are in content page
    expect(find.byKey(const Key('contentScaffold')), findsOneWidget);

    // go to profile page
    await tester.tap(find.byIcon(Icons.verified_user));
    await tester.pumpAndSettle();

    // logout
    await tester.tap(find.byKey(const Key('profileLogout')));
    await tester.pumpAndSettle();
  });
}
