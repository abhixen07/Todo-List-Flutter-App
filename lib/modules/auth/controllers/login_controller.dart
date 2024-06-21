import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/todo_management/firestore_list_screen.dart';
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
