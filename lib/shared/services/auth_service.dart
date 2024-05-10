import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:handees/shared/utils/utils.dart';

class AuthService {
  static final instance = AuthService._(FirebaseAuth.instance);
  final FirebaseAuth firebaseAuth;

  AuthService._(this.firebaseAuth) {
    firebaseAuth.idTokenChanges().listen((user) {
      user?.getIdToken().then((value) {
        if (value != null) {
          _token = value;
        }
      });
    });
  }

  User get user => firebaseAuth.currentUser!;

  String _token = "";

  String get token => _token;

  Future<void> getToken() async {
    final User? user = firebaseAuth.currentUser;
    final idToken = await user?.getIdToken();

    // idToken in the line should never be null
    if (idToken != null) {
      _token = idToken;
    }
    dPrint(_token);
  }

  bool doesTokenExist() {
    if (_token.isEmpty) return false;
    return true;
  }

  static bool isAuthenticated() => FirebaseAuth.instance.currentUser != null;
  static bool isProfileComplete() =>
      FirebaseAuth.instance.currentUser!.email != null &&
      FirebaseAuth.instance.currentUser!.email!.isNotEmpty &&
      FirebaseAuth.instance.currentUser!.displayName != null &&
      FirebaseAuth.instance.currentUser!.displayName!.isNotEmpty;

  Future<bool> emailInUse(String email) async {
    try {
      // Fetch sign-in methods for the email address
      final list = await firebaseAuth.fetchSignInMethodsForEmail(email);
      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        return true;
      } else {
        // Return false because email address is not in use
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return true;
    }
  }

  Future<AuthResponse> signinUser(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResponse.success;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occured';
      AuthResponse response;

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          response = AuthResponse.noSuchEmail;
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          response = AuthResponse.incorrectPassword;
          break;

        default:
          message = 'Auth Execption: $e';
          response = AuthResponse.unknownError;
      }

      debugPrint(message);
      return response;
    } catch (e) {
      final message = 'Auth Execption: $e';
      debugPrint(message);
      return AuthResponse.unknownError;
    }
  }

  ///Updates additional data on firebase authentication profile such as name,
  ///email and password
  ///
  ///Returns corresponding AuthResponse
  Future<AuthResponse> updateFirebaseProfile({
    String? email,
    String? password,
    String? name,
  }) async {
    final user = firebaseAuth.currentUser!;

    try {
      if (password != null) await user.updatePassword(password);
      if (name != null) await user.updateDisplayName(name);
      if (email != null) await user.updateEmail(email);

      return AuthResponse.success;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occured';
      AuthResponse response = AuthResponse.unknownError;

      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          response = AuthResponse.weakPassword;
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          response = AuthResponse.emailInUse;
          break;
        case 'invalid-email':
          message = 'Not a valid email';
          response = AuthResponse.invalidEmail;
          break;
        case 'requires-recent-login':
          message =
              'Requires recent login. Shouldn\'t occur as this is instantenous';
          break;

        default:
          message = e.toString();
      }

      debugPrint(message);
      return response;
    } catch (e) {
      final message = 'Auth Execption: $e';
      debugPrint(message);
      return AuthResponse.unknownError;
    }
  }

  Future<AuthResponse> verifyNumber(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      return AuthResponse.success;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occured';
      AuthResponse response;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'An account already exists for that phone number';
          response = AuthResponse.phoneInUse;
          break;
        case 'invalid-verification-code':
        case 'invalid-verification-id':
          message =
              'An error occured. Please try resending the verification code';
          response = AuthResponse.invalidVerificationCode;
          break;
        case 'invalid-phone-number':
          message = 'The phone number provided is not valid';
          response = AuthResponse.invalidPhone;
          break;
        default:
          message = e.toString();
          response = AuthResponse.unknownError;
      }
      debugPrint(message);
      return response;
    } catch (e) {
      final message = 'Auth Execption: $e';
      debugPrint(message);
      return AuthResponse.unknownError;
    }
  }

  Future<void> signupWithPhone({
    required String phone,
    required void Function(String verificationId, int? forceResendingToken)
        onCodeSent,
    required void Function(PhoneAuthCredential phoneAuthCredential)
        onVerifcationComplete,
    required void Function(FirebaseAuthException error) onVerificationFailed,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: onVerifcationComplete,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  void signoutUser(void Function() cb) async {
    await firebaseAuth.signOut();
    cb();
  }
}

enum AuthResponse {
  success,
  incorrectPassword,
  noSuchEmail,
  unknownError,
  weakPassword,
  emailInUse,
  phoneInUse,
  invalidEmail,
  invalidPhone,
  invalidVerificationCode,
}
