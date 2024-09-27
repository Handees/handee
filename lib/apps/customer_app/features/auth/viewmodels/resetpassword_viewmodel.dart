import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/customer_app/services/storage_service.customer.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/utils/utils.dart';

class ForgetPasswordViewModel extends ChangeNotifier with InputValidationMixin {
  ForgetPasswordViewModel(this._authService);

  final AuthService _authService;

  String _email = '';

  String? _emailError;
  String? get emailError => _emailError;

  bool _isResetSuccessful = false;
  bool get isResetSuccessful => _isResetSuccessful;

  bool _loading = false;
  bool get loading => _loading;
  WidgetRef? ref;

  void onEmailSaved(String? email) => _email = email!;

  String? emailValidator(String? email) {
    if (email != null && isEmailValid(email)) {
      return null;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}")
        .hasMatch(email!)) {
      return 'Please enter a valid email.';
    }
    return 'Invalid email';
  }

  Future<void> resetPassword({
    required void Function() onSuccess,
  }) async {
    _loading = true;
    resetErrors();
    notifyListeners();

    final response = await _authService.resetPassword(_email);

    switch (response) {
      case AuthResponse.success:
        onSuccess();
        _isResetSuccessful = true;
        break;
      case AuthResponse.noSuchEmail:
        _emailError = 'No account exists with this email';
        break;
      default:
        dPrint(response);
    }
    _loading = false;
    notifyListeners();
  }

  void resetErrors() {
    _emailError = null;
  }
}
