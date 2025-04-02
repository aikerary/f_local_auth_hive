import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find();
    return Center(
        child: ElevatedButton(
      key: const Key('profileLogout'),
      child: const Text('Logout'),
      onPressed: () {
        controller.logout();
      },
    ));
  }
}
