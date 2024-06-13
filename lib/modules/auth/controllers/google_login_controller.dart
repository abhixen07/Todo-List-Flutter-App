import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/utils/utils.dart';

class google extends GetxController{
  RxBool isSigning = false.obs;

  Future<void > signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      isSigning.value = true;

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await auth.signInWithCredential(credential);
        

        isSigning.value = false;
        // If sign-in succeeds, navigate to the next page
        Get.to(HomePage());
      }
    } catch (e) {
      Utils.snackBar('Error ',e.toString());
    }
  }
}