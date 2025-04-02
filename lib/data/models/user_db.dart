import 'package:hive/hive.dart';

part 'user_db.g.dart';

//execute dart run build_runner build to generate the .g file

@HiveType(typeId: 1)
class UserDb extends HiveObject {
  UserDb({
    required this.email,
    required this.password,
  });
  @HiveField(0)
  String email;
  @HiveField(1)
  String password;
}
