import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/modules/auth/controllers/google_login_controller.dart';

class SignInWithGoogle extends StatefulWidget {
  const SignInWithGoogle({Key? key}) : super(key: key);

  @override
  State<SignInWithGoogle> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {
  final googlestate = Get.put(google());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text('Sign In With Google'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: googlestate.signInWithGoogle,
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
                'assets/googlelogo.png', // Provide the path to your Google logo image
                height: 24,
              ),
              const SizedBox(width: 10),
              Obx(() => googlestate.isSigning.value
                  ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
                  : const Text(
                'Sign In With Google',
                style: TextStyle(color: Colors.black),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
