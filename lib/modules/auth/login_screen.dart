//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:todo_list/modules/auth/signup_screen.dart';
// import 'package:todo_list/pages/google_login.dart';
// import 'package:todo_list/pages/home_page.dart';
// import 'package:todo_list/utils/utils.dart';
// import 'package:todo_list/widgets/round_button.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }
//
//   void login() {
//     setState(() {
//       loading = true;
//     });
//     _auth
//         .signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text.toString())
//         .then((value) {
//       Utils().toastMessage(value.user!.email.toString());
//       Navigator.push(
//           // context, MaterialPageRoute(builder: (context) => FabTabs(selectedIndex: 0)));
//           context, MaterialPageRoute(builder: (context) => const HomePage()));
//       setState(() {
//         loading = false;
//       });
//     }).onError((error, stackTrace) {
//       debugPrint(error.toString());
//       Utils().toastMessage(error.toString());
//       setState(() {
//         loading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ignore: deprecated_member_use
//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return true;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Center(child: Text('Login')),
//           backgroundColor: const Color(0xffffcc00), // Set your desired color here
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/applogo.png',
//                 height: 100,
//                 width: 100,
//               ),
//               const SizedBox(height: 20,),
//               Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         controller: emailController,
//                         decoration: const InputDecoration(
//                             hintText: 'Email',
//                             prefixIcon: Icon(Icons.alternate_email)),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Enter email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         keyboardType: TextInputType.text,
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                             hintText: 'Password', prefixIcon: Icon(Icons.lock)),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Enter password';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   )
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               RoundButton(
//                 title: 'Login',
//                 loading: loading,
//                 onTap: () {
//                   if (_formKey.currentState!.validate()) {
//                     login();
//                   }
//                 },
//                 buttonColor: const Color(0xFFFFCC00), // Set your desired color here
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't have an account?"),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const SignUpScreen())
//                         );
//                       },
//                       child: const Text('Sign Up')
//                   )
//                 ],
//               ),
//               const SizedBox(height: 30,),
//               // InkWell(
//               //   onTap: (){
//               //     Navigator.push(
//               //         context,
//               //         MaterialPageRoute(builder: (context) => const SignInWithGoogle())
//               //     );
//               //   },
//               //   child: Container(
//               //     height: 50,
//               //     decoration: BoxDecoration(
//               //         borderRadius: BorderRadius.circular(50),
//               //         border: Border.all(
//               //           color: Colors.black,
//               //         )
//               //     ),
//               //     child: const Center(
//               //       child: Text('Sign In With Google'),
//               //     ),
//               //   ),
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
