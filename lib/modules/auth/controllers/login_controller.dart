import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/modules/auth/views/task_management_view.dart';
import 'package:todo_list/utils/utils.dart';

class LoginController extends GetxController {
  var loading = false.obs;
  final AuthRepository authRepository;

  LoginController({required this.authRepository});

  final Rx<FocusNode> emailFocusNode = FocusNode().obs;
  final Rx<FocusNode> passwordFocusNode = FocusNode().obs;
  final TextEditingController emailControllerlogin = TextEditingController();
  final TextEditingController passwordControllerlogin = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailFocusNode.value.dispose();
    passwordFocusNode.value.dispose();
    emailControllerlogin.dispose();
    passwordControllerlogin.dispose();
    super.onClose();
  }

  void login() async {
    loading(true);
    try {
      User? user = await authRepository.signInWithEmailAndPassword(emailControllerlogin.text, passwordControllerlogin.text);
      if (user != null) {
        Utils.snackBar('Welcome', user.email.toString());
        Get.offAll(() => FireStoreScreen());
      }
    } catch (e) {
      Utils.snackBar('Error', e.toString());
    } finally {
      loading(false);
    }
  }
}
