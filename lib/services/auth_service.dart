import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jkblog/services/database_services.dart';

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

      // If user creation is successful, store user data
      await DatabaseService().storeUserData(fullName, email);

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

      // If user creation is successful, store user data

      if (user != null) {
        await DatabaseService().storeUserData(user.displayName!, user.email!);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return e.toString();
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
