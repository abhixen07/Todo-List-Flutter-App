import 'package:get/get.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AuthController>(() => AuthController(authRepository: Get.find()));
  }
}