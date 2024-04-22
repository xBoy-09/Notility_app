import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notility/utils.dart';

class AuthServoce {
  // sign in with google
  signInWithGoogle() async {
    GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Link Google credential to existing Firebase account
        UserCredential userCredential = await currentUser.linkWithCredential(credential);
        bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
        if(isNewUser){
          await createNewuserData(FirebaseAuth.instance.currentUser!.uid);
        }
        // Return null because the user is still logged in with the same credentials
        return null;
      } else {
        // If no user is currently logged in, sign in with Google credential
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    }
  }

  unlinkGoogle() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Check if the user is linked with Google
      if (currentUser.providerData
          .any((info) => info.providerId == 'google.com')) {
        // Unlink Google credential from Firebase account
        await currentUser.unlink('google.com');
        print('Google account unlinked successfully.');
      } else {
        print('No Google account linked to this user.');
      }
    } else {
      print('No user signed in.');
    }
  }
}
