import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handees/apps/customer_app/features/auth/widgets/shared_widgets.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _obscureTextNotifier = ValueNotifier(true);
  String passwordError = "password do not match";
  void onPasswordSaved(String? password) {
    _password.text = password!;
  }
  void _onResetPressed() {
    var errors =  _formKey.currentState!.validate();
    if(errors == false){
      _formKey.currentState!.save();
    }
  }
  String? passwordValidator(String? password) {
    if (password != null && password.length > 6 && _password.value.text != _confirmPassword.value.text) {
      return null;
    }
    return 'Invalid password ' + passwordError;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Container(
          padding: EdgeInsets.only(bottom: 50.sp,top: 30),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                  image: AssetImage("assets/icon/reset.password.png"), fit: BoxFit.contain),
            ),
            child:  Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                const  Text(
                    "Reset \nPassword",
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  50.verticalSpace,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildPasswordField(password: _password, obscureTextNotifier: _obscureTextNotifier, passwordError: passwordError, passwordValidator: passwordValidator, onPasswordSaved: onPasswordSaved, hintText: 'New Password'),
                       20.verticalSpace,
                        buildPasswordField(password: _password, obscureTextNotifier: _obscureTextNotifier, passwordError: passwordError, passwordValidator: passwordValidator, onPasswordSaved: onPasswordSaved, hintText: 'Confirm Password'),
                      ],
                    ),
                  ),
                 30.verticalSpace,
                  GestureDetector(
                    onTap: _onResetPressed,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.h,
                      decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                      child: const Center(
                        child:  Text(
                          "Reset",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
