import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/controllers/google_login_controller.dart';

class SignInWithGoogle extends StatefulWidget {
  const SignInWithGoogle({super.key});

  @override
  State<SignInWithGoogle> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {
  final googlestate = Get.put(google());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
            onPressed: googlestate.signInWithGoogle,
            icon: const Icon(Icons.lock_outlined),
            label: Obx(() => googlestate.isSigning.value
                ? const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Text('Sign In With Google')),
          )

      ),
    );
  }


}