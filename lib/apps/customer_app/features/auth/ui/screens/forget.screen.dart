import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handees/apps/customer_app/features/auth/viewmodels/resetpassword_viewmodel.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/services/auth_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final forgetPasswordViewModelProvider =
      ForgetPasswordViewModel(AuthService.instance);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
            Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SvgPicture.asset("assets/svg/Ellipse.svg"),
              const Positioned(
                right: 70,
                top: 170,
                child: Image(image: AssetImage('assets/icon/forget_password.png')),
              ),
              ],
            ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Forgot \nPassword",
                style: TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Wrap(
                children: [
                  Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Volutpat dolor neque pulvinar diam purus. .")
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  onSaved: forgetPasswordViewModelProvider.onEmailSaved,
                  validator: forgetPasswordViewModelProvider.emailValidator,
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                child: Center(
                    child: InkWell(
                        onTap: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  _formKey.currentState!.save(),
                                  forgetPasswordViewModelProvider.resetPassword(
                                    onSuccess: () {
                                      Future.microtask(
                                        () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pushReplacementNamed(
                                                AuthRoutes.resetPassword),
                                      );
                                    },
                                    onUnknownError: () {},
                                  )
                                }
                            })
                  
                    ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ]),
      ),
    );
  }
}
