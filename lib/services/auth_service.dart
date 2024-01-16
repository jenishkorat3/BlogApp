import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  Future loginwithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future signUpUserwithEmailandPassword(String fullName, String email, String password) async {
    try {
      await (_auth.createUserWithEmailAndPassword(email: email, password: password));
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future googlesignInMethod() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOutMethod() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
