import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/res/icons.dart';


class buildPasswordField extends StatelessWidget {
    String hintText;
   TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
   ValueNotifier<bool> obscureTextNotifier = ValueNotifier(true);
  String passwordError = "password do not match";
  void Function(String?)  onPasswordSaved;
  String? Function(String?) passwordValidator;
  buildPasswordField({super.key, required this.password, required this.obscureTextNotifier, required this.passwordError, required this.passwordValidator, required this.onPasswordSaved, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextNotifier,
      builder: (context, obscureText, child) {
        return TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            constraints: BoxConstraints(
                maxHeight: 50.h
            ),
            hintText: hintText,
            prefixIcon: Image.asset("assets/icon/lock.png"),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? HandeeIcons.eyeTrackingOff
                    : HandeeIcons.eyeTrackingOn,
              ),
              color: obscureText
                  ? Theme.of(context).unselectedWidgetColor
                  : null,
              onPressed: () {
                obscureTextNotifier.value = !obscureText;
              },
            ),
            border:  const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          onSaved: onPasswordSaved,
          validator: passwordValidator,
        );
      },
    );
  }
}
