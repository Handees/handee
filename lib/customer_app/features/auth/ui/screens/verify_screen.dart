import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/routes/routes.dart';
import 'package:handees/theme/theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../providers/auth_provider.dart';

class VerifyScreen extends ConsumerWidget {
  VerifyScreen({Key? key}) : super(key: key);

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const verticalMargin = 24.0;

    final model = ref.watch(authProvider.notifier);
    final authState = ref.watch(authProvider);

    if (authState == AuthState.invalidVerificationCode)
      errorController.add(ErrorAnimationType.shake);

    // switch (authState) {
    //   case AuthState.invalidVerificationCode:
    //   case AuthState.verifying:
    //   case AuthState.loading:
    //     break;
    //   default:
    //     Future.microtask(() => Navigator.of(context).pop());
    //     break;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: Column(
          children: [
            Text('Code has been sent to *** ***${model.last2Digits}'),
            SizedBox(height: verticalMargin),
            Container(
              width: double.infinity,
              // height: 48,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  model.smsCode = value;
                },
                onCompleted: (_) => model.verifyNumber(),
                keyboardType: TextInputType.number,
                errorAnimationController: errorController,
                pinTheme: PinTheme(
                  borderRadius: BorderRadius.circular(4.0),
                  shape: PinCodeFieldShape.box,
                  activeColor: Theme.of(context).unselectedWidgetColor,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).unselectedWidgetColor,
                  // disabledColor: Theme.of(context).unselectedWidgetColor,
                ),
              ),
            ),
            SizedBox(height: verticalMargin),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Didn\'t get code? ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text('Request again'),
                ),
              ],
            ),
            SizedBox(height: verticalMargin),
            InkWell(
              onTap: () {
                // errorController.close()
              },
              child: Text('Get via call'),
            ),
            SizedBox(height: verticalMargin),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState == AuthState.loading
                    ? null
                    : () => model.verifyNumber(),
                style: Theme.of(context)
                    .extension<ButtonThemeExtensions>()
                    ?.filled,
                child: Text('Verify and Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}