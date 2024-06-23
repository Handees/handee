import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/customer_app/features/home/providers/user.provider.dart';
import 'package:handees/apps/customer_app/services/storage_service.customer.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/services/user_data_service.dart';
import 'package:handees/shared/utils/utils.dart';

class SigninViewmodel extends ChangeNotifier with InputValidationMixin {
  SigninViewmodel(this._authService, this._userDataService);

  final AuthService _authService;
  final UserDataService _userDataService;

  String _email = '';
  String _password = '';

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  bool _loading = false;
  bool get loading => _loading;

  WidgetRef? ref;

  void onEmailSaved(String? email) => _email = email!;
  void onPasswordSaved(String? password) => _password = password!;

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

  Future<void> checkIfUserExists(Function callback, int depth) async {
    if (ref != null) {
      final userNotifier = ref!.read(userProvider.notifier);
      await userNotifier.getUserObject();

      final user = ref!.read(userProvider);

      if (user.firstName.isNotEmpty) {
        callback();
      } else {
        // the depth is the number of times we want to retry submitting the user
        // but the user will be fetched depth + 1 times as we have to fetch for every submit user attempt
        if (depth == 0) return;

        // User is not on DB so register them
        final isUserSubmitted = await _userDataService.submitUser();

        // if user was still not submitted successfully
        if (!isUserSubmitted) return;

        // otherwise try to get the user object again
        checkIfUserExists(callback, depth - 1);
      }
    }
  }

  Future<void> signinUser({
    required void Function() onSuccess,
    required void Function() onUnknownError,
  }) async {
    _loading = true;
    resetErrors();
    notifyListeners();

    final response = await _authService.signinUser(_email, _password);

    switch (response) {
      case AuthResponse.success:
        await checkIfUserExists(onSuccess, 1);
        break;
      case AuthResponse.incorrectPassword:
        _passwordError = 'Incorrect password';
        break;
      case AuthResponse.noSuchEmail:
        _emailError = 'No account exists with this email';
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

  void resetErrors() {
    _emailError = null;
    _passwordError = null;
  }
}
