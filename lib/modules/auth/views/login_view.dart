import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/controllers/login_controller.dart';
import 'package:todo_list/modules/auth/controllers/google_login_controller.dart';
import 'package:todo_list/modules/auth/views/signup_view.dart';
import 'package:todo_list/widgets/custom_input_textfield.dart';
import 'package:todo_list/widgets/round_button.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final GoogleLoginController googleController = Get.put(GoogleLoginController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Login')),
        backgroundColor: const Color(0xffffcc00),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/applogo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: controller.emailControllerlogin,
                    hintText: 'Email',
                    prefixIcon: Icons.alternate_email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: controller.passwordControllerlogin,
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Login',
              loading: controller.loading.value,
              onTap: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.login();
                }
              },
              buttonColor: const Color(0xFFFFCC00),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Get.to(SignUpView());
                    },
                    child: const Text('Sign Up')),
              ],
            ),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
              onPressed: googleController.isSigning.value ? null : googleController.signInWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/googlelogo.png',
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Sign In With Google',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
