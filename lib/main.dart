// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/data/repositories/auth_repository.dart'; // Import the AuthRepository
import 'package:todo_list/modules/auth/bindings/auth_binding.dart';
import 'package:todo_list/modules/auth/controllers/auth_controller.dart';
import 'package:todo_list/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // Initialize AuthRepository
  // AuthRepository authRepository = AuthRepository();
  //
  // // Initialize AuthController with AuthRepository
  // Get.put(AuthController(authRepository: authRepository));

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
          binding: AuthBinding(), // Bind AuthController in SplashScreen
        ),
      ],
    );
  }
}
