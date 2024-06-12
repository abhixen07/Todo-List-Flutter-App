// auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/utils/utils.dart';

class AuthController extends GetxController {
  var loading = false.obs;
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  final TextEditingController emailController1 = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController emailController2 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final formKey = GlobalKey<FormState>(); // Add formKey here

  @override
  void onClose() {
    emailController1.dispose();
    passwordController1.dispose();
    emailController2.dispose();
    passwordController2.dispose();
    super.onClose();
  }

  void login() async {
    loading(true);
    try {
      User? user = await authRepository.signInWithEmailAndPassword(emailController1.text, passwordController1.text);
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

  void signUp() async {
    loading(true);
    try {
      User? user = await authRepository.signUpWithEmailAndPassword(emailController2.text, passwordController2.text);
      if (user != null) {
        Utils().toastMessage('Account created for ${user.email}');
        Get.offAll(() => LoginView());
      }
    } catch (e) {
      Utils().toastMessage(e.toString());
    } finally {
      loading(false);
    }
  }
}
