import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:handees/apps/customer_app/services/storage_service.customer.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/services/user_data_service.dart';
import 'package:handees/shared/utils/utils.dart';

class SignupViewmodel extends ChangeNotifier with InputValidationMixin {
  SignupViewmodel(this._authService, this._userDataService);

  final AuthService _authService;
  final UserDataService _userDataService;

  String _name = '';
  String _phone = '';
  String _email = '';
  String _password = '';

  String get last2Digits => _phone.substring(_phone.length - 2, _phone.length);

  String _smsCode = '';
  set smsCode(String code) => _smsCode = code;
  late String _verificationId;

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  String? _phoneError;
  String? get phoneError => _phoneError;

  bool _verificationCodeError = false;
  bool get verificationCodeError => _verificationCodeError;

  bool _loading = false;
  bool get loading => _loading;

  void onEmailSaved(String? email) => _email = email!;
  void onPasswordSaved(String? password) => _password = password!;
  void onNameSaved(String? name) => _name = name!;
  void onPhoneSaved(String? phone) => _phone = phone!;

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

  Future<void> _completeProfile({
    required void Function() onSuccess,
    required void Function() onUnknownError,
  }) async {
    final completeResponse = await _authService.updateFirebaseProfile(
        email: _email, password: _password, name: _name);

    switch (completeResponse) {
      case AuthResponse.success:
        debugPrint('Verfication completed');
        _userDataService.submitUser();
        onSuccess();
        break;
      case AuthResponse.weakPassword:
        _passwordError = 'Password too weak';
        break;
      case AuthResponse.emailInUse:
        _emailError = 'An account already exists with this email';
        break;
      case AuthResponse.invalidEmail:
        _emailError = 'Not a valid email';
        break;
      case AuthResponse.unknownError:
        onUnknownError();
        break;
      default:
        onUnknownError();
    }
    notifyListeners();
  }

  Future<void> _verifyNumber({
    PhoneAuthCredential? phoneAuthCredential,
    required void Function() onSuccess,
    required void Function() onUnknownError,
  }) async {
    _loading = true;
    resetErrors();
    notifyListeners();
    PhoneAuthCredential credential = phoneAuthCredential ??
        PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _smsCode,
        );

    final response = await _authService.verifyNumber(credential);

    switch (response) {
      case AuthResponse.success:
        _completeProfile(onSuccess: onSuccess, onUnknownError: onUnknownError);

        break;
      case AuthResponse.phoneInUse:
        _phoneError = 'An account already exists with this phone number';
        break;
      case AuthResponse.invalidPhone:
        _phoneError = 'Not a valid phone number';
        break;
      case AuthResponse.invalidVerificationCode:
        _verificationCodeError = true;
        break;
      case AuthResponse.unknownError:
        onUnknownError();
        break;
      default:
        onUnknownError();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> signupUser({
    required void Function({required void Function() onVerifyNumber})
        onCodeSent,
    required void Function() onVerificationComplete,
    required void Function() onUnkownError,
  }) async {
    _loading = true;

    notifyListeners();

    if (await _authService.emailInUse(_email)) {
      _emailError = 'An account already exists with this email';
      dPrint(_emailError);
      _loading = false;
      notifyListeners();
      return;
    }

    await _authService.signupWithPhone(
      phone: _phone,
      onCodeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        onCodeSent(
          onVerifyNumber: () {
            dPrint("Let's try");
            _verifyNumber(
              onSuccess: onVerificationComplete,
              onUnknownError: onUnkownError,
            );
          },
        );

        _loading = false;
        notifyListeners();
      },
      onVerifcationComplete: (phoneAuthCredential) {
        _verifyNumber(
          phoneAuthCredential: phoneAuthCredential,
          onSuccess: onVerificationComplete,
          onUnknownError: onUnkownError,
        );

        _loading = false;
        notifyListeners();
      },
      onVerificationFailed: (error) {
        debugPrint('Phone verification failed with error $error');
        onUnkownError();
        _loading = false;
        notifyListeners();
      },
    );
  }

  void resetErrors() {
    _emailError = null;
    _passwordError = null;
    _phoneError = null;
    _verificationCodeError = false;
  }
}
