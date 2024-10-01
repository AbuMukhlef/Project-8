import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onze_cafe/extensions/screen_size.dart';
import 'package:onze_cafe/reusable_components/custom_text_field.dart';
import 'package:onze_cafe/screens/edit_profile/edit_profile_cubit.dart';

import '../../extensions/color_ext.dart';
import '../../extensions/img_ext.dart';
import '../../model/profile.dart';
import '../../utils/validations.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, this.profile});
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return BlocProvider(
      create: (context) => EditProfileCubit(profile),
      child: Builder(builder: (context) {
        final cubit = context.read<EditProfileCubit>();
        return Scaffold(
          backgroundColor: C.bg1(brightness),
          appBar: AppBar(
            backgroundColor: C.bg1(brightness),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(CupertinoIcons.chevron_left_square_fill),
              iconSize: 40,
              color: C.primary(brightness),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: context.screenWidth * 0.4,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: C.primary(brightness), width: 2)),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: InkWell(
                                  onTap: cubit.getImage,
                                  child: ClipOval(
                                    child: cubit.avatar != null
                                        ? Image.file(cubit.avatar!,
                                            fit: BoxFit.contain)
                                        : profile?.avatarUrl == null
                                            ? const Icon(
                                                CupertinoIcons
                                                    .photo_on_rectangle,
                                                size: 40)
                                            : Image.network(profile!.avatarUrl!,
                                                fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        CustomTextField(
                          hintText: 'Name',
                          controller: cubit.nameController,
                          validation: Validations.name,
                        ),
                        CustomTextField(
                          hintText: 'Email',
                          controller: cubit.emailController,
                          validation: Validations.name,
                        ),
                        CustomTextField(
                          hintText: 'Phone',
                          controller: cubit.phoneController,
                          validation: Validations.name,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
