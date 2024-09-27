import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handees/apps/customer_app/features/auth/viewmodels/resetpassword_viewmodel.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/services/auth_service.dart';

class ForgetPasswordScreen extends ConsumerWidget {
  ForgetPasswordScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final forgetPasswordViewModel = ForgetPasswordViewModel(AuthService.instance);
  final ScrollController _controller = ScrollController();

  void scrollToBottom() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    forgetPasswordViewModel.ref = ref;

    return AnimatedBuilder(
        animation: forgetPasswordViewModel,
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                controller: _controller,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      (forgetPasswordViewModel.isResetSuccessful ? 1.1 : 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Your other images here
                      const SizedBox(
                        height: 200,
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset('assets/icon/Ellipse_78.png'),
                          Image.asset('assets/icon/forget_password.png'),
                        ],
                      ),

                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Forgot \nPassword?",
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
                                    "No worries! Just enter your email below, and we'll send you instructions to reset your password. You'll be back in no time!")
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                scrollPadding:
                                    const EdgeInsets.only(bottom: 200),
                                onSaved: forgetPasswordViewModel.onEmailSaved,
                                validator:
                                    forgetPasswordViewModel.emailValidator,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  hintText: "Email Address",
                                  errorText: forgetPasswordViewModel.emailError,
                                ),
                              ),
                            ),
                            20.verticalSpace,
                            if (forgetPasswordViewModel.isResetSuccessful) ...[
                              const Text(
                                  "Your request to reset your password was successful. Please check your email for the reset link and follow the instructions to set a new password."),
                              20.verticalSpace,
                            ],
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xffFFFFFF)),
                              child: Center(
                                child: InkWell(
                                  onTap: forgetPasswordViewModel.loading
                                      ? null
                                      : () => {
                                            if (_formKey.currentState!
                                                .validate())
                                              {
                                                _formKey.currentState!.save(),
                                                forgetPasswordViewModel
                                                    .resetPassword(
                                                  onSuccess: scrollToBottom,
                                                )
                                              }
                                          },
                                  child: forgetPasswordViewModel.loading
                                      ? const SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        )
                                      : const Text(
                                          "Send Link",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                ),
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
              ),
            ),
          );
        });
  }
}
