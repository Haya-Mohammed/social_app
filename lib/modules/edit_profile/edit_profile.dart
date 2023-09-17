import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var profileCover = SocialCubit.get(context).profileCover;

        nameController.text = model!.name!;
        bioController.text = model!.bio!;
        phoneController.text = model!.phone!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                child: const Text('Edit'),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUpdateUserLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: profileCover == null
                                        ? NetworkImage('${model!.cover}')
                                        : FileImage(File(profileCover.path))
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileCover();
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                child: Icon(IconBroken.Camera),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${model!.image}')
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                child: Icon(IconBroken.Camera),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        if (profileImage != null)
                          Expanded(
                            child: defaultButton(
                              function: () {
                                SocialCubit.get(context).uploadProfileImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              text: 'Upload Profile',
                            ),
                          ),
                        const SizedBox(width: 5),
                        if (profileCover != null)
                          Expanded(
                            child: defaultButton(
                              function: () {
                                SocialCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              text: 'Upload Cover',
                            ),
                          ),
                      ],
                    ),
                  ),
                  defaultFormField(
                    label: 'Name',
                    prefix: IconBroken.User,
                    controller: nameController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'name must not be empty!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  defaultFormField(
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
                    controller: bioController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'bio must not be empty!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  defaultFormField(
                    label: 'Phone Number',
                    prefix: IconBroken.Call,
                    controller: phoneController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'phone number must not be empty!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
