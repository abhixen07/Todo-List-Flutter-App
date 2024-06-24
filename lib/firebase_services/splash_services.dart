import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';
import 'package:todo_list/modules/auth/views/task_management_view.dart';

class SplashServices {
  Future<void> isLogin() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    await Future.delayed(const Duration(seconds: 3), () {
      if (user!= null) {
        Get.offAll(() => FireStoreScreen(user: user));
      } else {
        Get.offAll(() => LoginView());
      }
    });
  }
}