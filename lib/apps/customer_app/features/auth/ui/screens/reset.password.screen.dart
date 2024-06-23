import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../shared/res/icons.dart';

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
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 230.0),
                child: SvgPicture.asset("assets/svg/key.svg"),
              ),
            ],
          ),
          Positioned(
              right: 100,
              top: 180,
              child: Image(
                image: AssetImage("assets/icon/key.png"),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Reset \nPassword",
                style: TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureTextNotifier,
                      builder: (context, obscureText, child) {
                        return TextFormField(
                            obscureText: obscureText,
                            decoration: InputDecoration(
                            hintText: 'New password',
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
                              _obscureTextNotifier.value = !obscureText;
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
                    ),
                    SizedBox(height: 20,),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureTextNotifier,
                      builder: (context, obscureText, child) {
                        return TextFormField(
                          obscureText: obscureText,
                          onSaved: onPasswordSaved,
                          validator: passwordValidator,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
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
                                _obscureTextNotifier.value = !obscureText;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: (){
                 var errors =  _formKey.currentState!.validate();
                 if(errors == false){
                   _formKey.currentState!.save();

                 }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(color: Color(0xffFFFFFF)),
                  child: Center(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ]),
      ),
    );
  }
}
