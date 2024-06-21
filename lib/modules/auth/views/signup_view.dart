import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/controllers/signup_controller.dart';
import 'package:todo_list/modules/auth/views/login_view.dart';
import 'package:todo_list/widgets/custom_input_textfield.dart';
import 'package:todo_list/widgets/round_button.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.find<SignUpController>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF075E59),
        title: const Center(child: Text('Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
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
              Column(
                children: [
                  CustomTextFormField(
                    controller: controller.emailControllersignup,
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
                    controller: controller.passwordControllersignup,
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
              const SizedBox(height: 50),
              Obx(() => RoundButton(
                title: 'Sign Up',
                loading: controller.loading.value,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.signUp();
                  }
                },
                buttonColor: const Color(0xFF075E59),
              )),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.to(LoginView());
                    },
                    child: const Text('Login',style: TextStyle(color: Colors.teal)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
