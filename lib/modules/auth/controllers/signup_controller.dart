import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';
import 'package:todo_list/utils/utils.dart';

class SignUpController extends GetxController {
  var loading = false.obs;
  final AuthRepository authRepository;

  SignUpController({required this.authRepository});

  final Rx<FocusNode> emailFocusNode = FocusNode().obs;
  final Rx<FocusNode> passwordFocusNode = FocusNode().obs;
  final TextEditingController emailControllersignup = TextEditingController();
  final TextEditingController passwordControllersignup = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailFocusNode.value.dispose();
    passwordFocusNode.value.dispose();
    emailControllersignup.dispose();
    passwordControllersignup.dispose();
    super.onClose();
  }

  void signUp() async {
    loading(true);
    try {
      User? user = await authRepository.signUpWithEmailAndPassword(emailControllersignup.text, passwordControllersignup.text);
      if (user != null) {
        Utils.snackBar('Account created for', user.email.toString());
        Get.offAll(() => LoginView());
      }
    } catch (e) {
      Utils.snackBar('Error', e.toString());
    } finally {
      loading(false);
    }
  }
}
