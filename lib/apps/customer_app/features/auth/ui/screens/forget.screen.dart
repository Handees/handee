import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handees/shared/routes/routes.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Email: $_email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svg/Ellipse.svg")
            ],
          ),
          Positioned(
            right: 70,
            top: 170,
            child: Image(image:AssetImage('assets/icon/forget_password.png')),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Forgot \nPassword",
                style: TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Wrap(
                children: [
                  Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat dolor neque pulvinar diam purus. .")
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType:TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email.';
                    }
                    else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}").hasMatch(value)) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!; // Save the entered email
                  },
                ),
            ),
              SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height:60,
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF)
              ),
              child: Center(
                child:  InkWell(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AuthRoutes.resetPassword),
                  child:  Text("Send Link",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                  ),),
                ),
              ),
            ),
              SizedBox(height: 40,)
            ],
          ),
        ]),
      ),
    );
  }
}
