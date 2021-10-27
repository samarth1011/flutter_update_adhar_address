// ignore_for_file: constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Exception Status Code for FirebaseAuth Exceptions
  static const String USER_NOT_FOUND_EXCEPTION_CODE = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION_CODE = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION_CODE =
      "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION_CODE =
      "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION_CODE = "weak-password";
  static const String USER_MISMATCH_EXCEPTION_CODE = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION_CODE = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION_CODE = "invalid-email";
  static const String USER_DISABLED_EXCEPTION_CODE = "user-disabled";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION_CODE =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION_CODE =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION_CODE =
      "requires-recent-login";

  // Phone Auth Test Details
  static String testPhoneNumber = "+91 7123 123456";
  static String testOtpCode = "000000";

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // making class singleton
  AuthService._privateConstructor();
  static AuthService instance = AuthService._privateConstructor();

  /// get stream of Auth Status Changes
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  /// sign in user with given User Credentials
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    //assert(credential != null, "credentials cannot be null");
    // login with credentials
    final userCredentials = await firebaseAuth.signInWithCredential(credential);
    return userCredentials;
  }

  /// sign in using Google Auth Provider of FirebaseAuth
  Future<UserCredential?> signInWithGoogle(
      GoogleSignInAccount googleUser) async {
    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await signInWithCredential(credential);
  }

  Future<GoogleSignInAccount?> promptSelectGoogleAccount() async {
    final googleUser = await GoogleSignIn().signIn();
    return googleUser;
  }

  /// sign out from FirebaseAuth
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// get User instance of currentUser
  User? get currentUser {
    return firebaseAuth.currentUser;
  }

  /// Returns the email of currently logged in user otherwise returns null
  String? get currentUserEmail {
    if (currentUser != null) {
      return (currentUser!).email;
    }
  }

  /// get PhotoUrl for user google display image
  String? get userPhotoUrl {
    final url = currentUser?.photoURL?.replaceAll("s96-c", "s400-c");
    return url;
  }

  /// get current users display name
  String? get currentUserName {
    if (currentUser != null) {
      return currentUser?.displayName;
    }
    return null;
  }

  /// get current users first name
  String? get currentUserFirstName {
    if (currentUserName != null) {
      return currentUserName?.split(" ").first;
    }
    return null;
  }

  /// get current users last name
  String? get currentUsersLastName {
    if (currentUserName != null) {
      return currentUserName?.split(" ").last;
    }
    return null;
  }
}
