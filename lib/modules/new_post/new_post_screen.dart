import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  TextEditingController postTextController = TextEditingController();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'New Post',
            actions: [
              TextButton(
                onPressed: () {
                  if (SocialCubit.get(context).postImage != null) {
                    SocialCubit.get(context).uploadPostImage(
                      text: postTextController.text,
                      dateTime: dateTime.toString(),
                    );
                  } else {
                    SocialCubit.get(context).createPost(
                      text: postTextController.text,
                      dateTime: dateTime.toString(),
                    );
                  }
                },
                child: const Text('Post'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
                  const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        SocialCubit.get(context).userModel!.image,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        SocialCubit.get(context).userModel!.name,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: postTextController,
                    decoration: const InputDecoration(
                      hintText: 'what is in your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (SocialCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0,),
                          image: DecorationImage(
                            image: FileImage(SocialCubit.get(context).postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          SocialCubit.get(context).removePostImage();
                        },
                        icon: const Icon(IconBroken.Close_Square),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5),
                            Text('add photo'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tag),
                            SizedBox(width: 5),
                            Text('tags'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
