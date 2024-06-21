import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/modules/auth/views/task_management_view.dart';
import 'package:todo_list/utils/utils.dart';

class GoogleLoginController extends GetxController {
  RxBool isSigning = false.obs;

  Future<void> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      isSigning.value = true;

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await auth.signInWithCredential(credential);

       // Utils.toastMessage('Sign in successful');
        Get.offAll(() => FireStoreScreen());
      } else {
       // Utils.toastMessage('Google sign in aborted');
      }
    } catch (e) {
      Utils.snackBar('Error', e.toString());
    } finally {
      isSigning.value = false;
    }
  }
}
