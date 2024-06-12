import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/utils/utils.dart';

class LoginController extends GetxController {
  var loading = false.obs;
  final AuthRepository authRepository;

  LoginController({required this.authRepository});

  final TextEditingController emailControllerlogin = TextEditingController();
  final TextEditingController passwordControllerlogin = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailControllerlogin.dispose();
    passwordControllerlogin.dispose();
    super.onClose();
  }

  void login() async {
    loading(true);
    try {
      User? user = await authRepository.signInWithEmailAndPassword(emailControllerlogin.text, passwordControllerlogin.text);
      if (user != null) {
        Utils().toastMessage('Welcome ${user.email}');
        Get.offAll(() => HomePage());
      }
    } catch (e) {
      Utils().toastMessage(e.toString());
    } finally {
      loading(false);
    }
  }
}
