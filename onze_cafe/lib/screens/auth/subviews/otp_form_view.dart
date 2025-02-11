import 'package:flutter/material.dart';
import 'package:onze_cafe/extensions/string_ex.dart';
import 'package:onze_cafe/reusable_components/buttons/primary_btn_view.dart';
import 'package:onze_cafe/screens/auth/network_functions.dart';

import '../../../extensions/color_ext.dart';
import '../auth_cubit.dart';
import 'package:pinput/pinput.dart';

class OtpFormView extends StatelessWidget {
  const OtpFormView({super.key, required this.cubit});
  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final defaultPinTheme = PinTheme(
      textStyle: const TextStyle(
          fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(50),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
          color: C.primary(brightness),
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter),
      borderRadius: BorderRadius.circular(50),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white38,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP',
              ).styled(size: 24, weight: FontWeight.bold),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  'An OTP verification code was sent to',
                ).styled(color: Colors.black45),
                Text(
                  cubit.emailController.text,
                ).styled(color: C.primary(brightness)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'OTP Verification code: *',
                ).styled(weight: FontWeight.bold),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 7,
                  child: Pinput(
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    length: 6,
                    showCursor: true,
                    onCompleted: (pin) {
                      cubit.otp = int.tryParse(pin) ?? -1;
                      cubit.verifyOtp(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              TextButton(
                  onPressed: cubit.toggleIsOtp, child: Text('Cancel').styled())
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextButton(
              onPressed: () => cubit.signIn(context),
              child: Text(
                'Resend OTP',
              ).styled(color: C.primary(brightness)),
            ),
          ),
          PrimaryBtnView(
              title: 'Verify', callback: () => cubit.verifyOtp(context))
        ],
      ),
    );
  }
}
