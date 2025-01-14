import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onze_cafe/extensions/color_ext.dart';
import 'package:onze_cafe/extensions/string_ex.dart';
import 'package:onze_cafe/reusable_components/custom_text_field.dart';
import 'package:onze_cafe/reusable_components/buttons/primary_btn_view.dart';
import 'package:onze_cafe/screens/auth/auth_cubit.dart';
import 'package:onze_cafe/screens/auth/network_functions.dart';
import 'package:onze_cafe/utils/validations.dart';

class SignupFormView extends StatelessWidget {
  const SignupFormView({super.key, required this.cubit});
  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text('Sign Up').styled(
                size: 20,
                color: C.secondary(brightness),
                weight: FontWeight.bold),
          ),
          CustomTextField(
              hintText: 'Full Name',
              controller: cubit.nameController,
              validation: Validations.name),
          CustomTextField(
              hintText: 'Email',
              controller: cubit.emailController,
              validation: Validations.email),
          CustomTextField(
              hintText: 'Phone Number',
              controller: cubit.phoneController,
              validation: Validations.phoneNumber),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                  hintText: 'Password',
                  controller: cubit.passwordController,
                  isObscure: cubit.isObscure,
                  validation: Validations.password),
              IconButton(
                  onPressed: cubit.toggleIsObscure,
                  icon: Icon(
                      cubit.isObscure
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: C.secondary(brightness)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryBtnView(
                    title: 'Sign Up',
                    callback: () => cubit.signUp(context),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Text("Already have an account")
                  .styled(weight: FontWeight.w500),
              TextButton(
                  onPressed: cubit.toggleIsSignUp,
                  child: const Text('Sign In').styled(
                      weight: FontWeight.w500, color: C.secondary(brightness)))
            ],
          )
        ],
      ),
    );
  }
}
