import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        automaticallyImplyLeading: false, // Removes the back button
        backgroundColor: const Color(0xFF075E59),
        title: Center(
          child: Text(
            'Login',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/applogo.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
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
                    focusNode: controller.emailFocusNode.value,
                    nextFocusNode: controller.passwordFocusNode.value,
                  ),
                  const SizedBox(height: 20),
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
                    focusNode: controller.passwordFocusNode.value,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => RoundButton(
                    title: 'Login',
                    loading: controller.loading.value,
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.login();
                      }
                    },
                    buttonColor: const Color(0xFF075E59),
                  ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(SignUpView());
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
              onPressed: googleController.isSigning.value ? null : googleController.signInWithGoogle,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/googlelogo.png',
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Sign In With Google',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
