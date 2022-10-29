import 'package:auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/customer_app/services/auth_service.dart';
import 'package:handees/utils/utils.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  // final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(AuthService.instance);
});

class AuthStateNotifier extends StateNotifier<AuthState>
    with InputValidationMixin {
  AuthStateNotifier(this.authService)
      : super(authService.isAuthenticated()
            ? AuthState.authenticated
            : AuthState.waiting);

  final AuthService authService;

  String _name = '';
  String _phone = '';
  String _email = '';
  String _password = '';

  String _smsCode = '';
  set smsCode(String code) => _smsCode = code;
  late String _verificationId;

  String get last2Digits => _phone.substring(_phone.length - 2, _phone.length);

  String? emailValidator(String? email) {
    if (email != null && isEmailValid(email)) {
      return null;
    }

    return 'Invalid email';
  }

  String? passwordValidator(String? password) {
    if (password != null && isPasswordValid(password)) {
      return null;
    }

    return 'Invalid password';
  }

  String? nameValidator(String? name) {
    if (name != null && name.isNotEmpty) {
      return null;
    }

    const errorMessage = 'Name must be at least a character';
    return errorMessage;
  }

  String? phoneValidator(String? phone) {
    if (phone != null && isNumberValid(phone)) {
      return null;
    }

    return 'Invalid phone';
  }

  void onEmailSaved(String? email) => _email = email!;
  void onPasswordSaved(String? password) => _password = password!;
  void onNameSaved(String? name) => _name = name!;
  void onPhoneSaved(String? phone) => _phone = phone!;

  void signinUser() async {
    // if (!_formGlobalKey.currentState!.validate()) return;

    // _formGlobalKey.currentState?.save();
    // print(
    //     'Email: $email, Password: $password, Name: $name');
    state = AuthState.loading;
    final response = await authService.signinUser(_email, _password);
    // await Future.delayed(Duration(seconds: 2));

    switch (response) {
      case AuthResponse.success:
        state = AuthState.authenticated;
        break;
      case AuthResponse.incorrectPassword:
        state = AuthState.invalidPassword;
        break;
      case AuthResponse.noSuchEmail:
        state = AuthState.noSuchEmail;
        break;
      case AuthResponse.unknownError:
        state = AuthState.waiting;
        break;
      default:
        state = AuthState.waiting;
    }
  }

  void verifyNumber() async {
    state = AuthState.loading;
    final response = await authService.verifyNumber(_smsCode, _verificationId);
    // await Future.delayed(Duration(seconds: 2));

    switch (response) {
      case AuthResponse.success:
        final completeResponse =
            await authService.completeProfile(_email, _password, _name);

        switch (completeResponse) {
          case AuthResponse.success:
            state = AuthState.authenticated;
            break;
          case AuthResponse.weakPassword:
            state = AuthState.invalidPassword;
            break;
          case AuthResponse.emailInUse:
            state = AuthState.emailInUse;
            break;
          case AuthResponse.invalidEmail:
            state = AuthState.invalidEmail;
            break;
          case AuthResponse.unknownError:
            state = AuthState.waiting;
            break;
          default:
            state = AuthState.waiting;
        }

        break;
      case AuthResponse.phoneInUse:
        state = AuthState.phoneInUse;
        break;
      case AuthResponse.invalidPhone:
        state = AuthState.invalidPhone;
        break;
      case AuthResponse.invalidVerificationCode:
        state = AuthState.invalidVerificationCode;
        break;
      case AuthResponse.unknownError:
        state = AuthState.waiting;
        break;
      default:
        state = AuthState.waiting;
    }
  }

  void signupUser({required void Function() onCodeSent}) async {
    state = AuthState.loading;

    if (await authService.emailInUse(_email)) {
      state = AuthState.emailInUse;
      return;
    }

    authService.signupWithPhone(
      phone: _phone,
      onCodeSent: (verificationId, forceResendingToken) {
        state = AuthState.verifying;
        _verificationId = verificationId;
        onCodeSent();
      },
      onVerifcationComplete: (phoneAuthCredential) async {
        resetState();
        state = AuthState.authenticated;
      },
      onVerificationFailed: (error) {
        debugPrint('Phone verification failed with error $error');
        state = AuthState.waiting;
      },
    );
    // await Future.delayed(Duration(seconds: 2));

    // switch (response) {
    //   case AuthResponse.success:
    //     state = AuthState.authenticated;
    //     break;
    //   case AuthResponse.weakPassword:
    //     state = AuthState.invalidPassword;
    //     break;
    //   case AuthResponse.emailInUse:
    //     state = AuthState.emailInUse;
    //     break;
    //   case AuthResponse.invalidPhone:
    //     state = AuthState.invalidPhone;
    //     break;

    //   case AuthResponse.phoneInUse:
    //     state = AuthState.phoneInUse;
    //     break;
    //   case AuthResponse.unknownError:
    //     state = AuthState.waiting;
    //     break;
    //   default:
    //     state = AuthState.waiting;
    // }
  }

  // void signoutUser() {
  //   resetState();
  //   authService.signoutUser();
  // }

  void resetState() {
    _email = '';
    _name = '';
    _password = '';
    _phone = '';
    state = AuthState.waiting;
  }
}

enum AuthState {
  waiting,
  loading,
  verifying,
  authenticated,
  noSuchEmail,
  invalidPassword,
  invalidPhone,
  invalidVerificationCode,
  invalidEmail,
  emailInUse,
  phoneInUse,
}