import 'package:flutter/material.dart';
import 'package:handees/customer_app/features/auth/ui/screens/signin_screen.dart';
import 'package:handees/customer_app/features/auth/ui/screens/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignin = true;

  void _onSwapScreen() => setState(() {
        _isSignin = !_isSignin;
      });

  @override
  Widget build(BuildContext context) {
    return _isSignin
        ? SigninScreen(
            onSwapScreen: _onSwapScreen,
          )
        : SignupScreen(
            onSwapScreen: _onSwapScreen,
          );
  }
}