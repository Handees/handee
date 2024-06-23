import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  image: AssetImage('assets/icon/Ellipse_78.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Your other images here
            Positioned(
              top: 170,
              left: 70,
              child: Image.asset('assets/icon/forget_password.png'),
            ),
             Padding(
               padding: const EdgeInsets.only(left: 8.0),
               child: Column(
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
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                        controller: _emailController,
                        onSaved: forgetPasswordViewModelProvider.onEmailSaved,
                        validator: forgetPasswordViewModelProvider.emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                          ),
                        )
                    ),
                  ),
                   20.verticalSpace,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration:  BoxDecoration(
                         borderRadius: BorderRadius.circular(5),
                        color: const Color(0xffFFFFFF)),
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
                                            .pushNamed(
                                            AuthRoutes.resetPassword),
                                      );
                                    },
                                    onUnknownError: () {},
                                  )
                                }
                            },
                          child: const Text("Send Link",style: TextStyle(
                              color: Colors.black,
                            fontWeight: FontWeight.w500
                          ),),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
                           ),
             ),
          ],
        ),
        ),
      );
  }
}
