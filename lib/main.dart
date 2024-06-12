import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';
import 'package:todo_list/modules/auth/controllers/login_controller.dart';
import 'package:todo_list/modules/auth/controllers/signup_controller.dart';
import 'package:todo_list/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize AuthRepository
  final authRepository = AuthRepository();

  // Initialize controllers
  Get.put(LoginController(authRepository: authRepository));
  Get.put(SignUpController(authRepository: authRepository));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login With Google',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
        ),
      ],
    );
  }
}
