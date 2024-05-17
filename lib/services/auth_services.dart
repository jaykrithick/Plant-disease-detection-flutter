import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantie/models/user.dart';

Future<void> signInWithGoogle() async {
  // Trigger the authentication flow
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  } catch (e) {
    return null;
  }
}

Future<void> signOutWithGoogle() async {
  try {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  } catch (e) {
    print("Failed to sign out with Google. Error: $e");
  }
}

Future<UserModel> signUpWithEmailAndPassword(
    String email, String password, String name) async {
  try {
    UserCredential result =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.user!.sendEmailVerification();
    result.user!.updateDisplayName(name);
    return UserModel(
        userError: UserError.none, userStatus: UserStatus.loggedOut);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      return UserModel(
          userError: UserError.wrongPassword, userStatus: UserStatus.loggedOut);
    } else if (e.code == 'invalid-email') {
      return UserModel(
          userError: UserError.invalidEmail, userStatus: UserStatus.loggedOut);
    } else if (e.code == 'email-already-in-use') {
      return UserModel(
          userError: UserError.emailAlreadyInUse,
          userStatus: UserStatus.loggedOut);
    } else if (e.code == 'weak-password') {
      return UserModel(
          userError: UserError.weakPassword, userStatus: UserStatus.loggedOut);
    }
    return UserModel(
        userError: UserError.invalidCredentials,
        userStatus: UserStatus.loggedOut);
  }
}

Future<UserModel> signInWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (result.user!.emailVerified == false) {
      return UserModel(
          userError: UserError.none, userStatus: UserStatus.loggedOut);
    }
    return UserModel(
        userError: UserError.none, userStatus: UserStatus.loggedIn);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      return UserModel(
          userError: UserError.wrongPassword, userStatus: UserStatus.loggedOut);
    } else if (e.code == 'invalid-email') {
      return UserModel(
          userError: UserError.invalidEmail, userStatus: UserStatus.loggedOut);
    }
    return UserModel(
        userError: UserError.invalidCredentials,
        userStatus: UserStatus.loggedOut);
  }
}
