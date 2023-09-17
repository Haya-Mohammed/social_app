import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var model = SocialCubit.get(context).userModel;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 190.0,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
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
                        image: NetworkImage('${model!.cover}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('${model!.image}'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${model!.name}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            '${model!.bio}',
            style: Theme.of(context).textTheme.caption,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(
                          '100',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          'Posts',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(
                          '294',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          'Photos',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(
                          '36',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          'Following',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(
                          '10k',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Add Photos'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
                child: const Icon(IconBroken.Edit),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  FirebaseMessaging.instance.subscribeToTopic('announcement');
                },
                child: const Text('Subscribe'),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {
                  FirebaseMessaging.instance.unsubscribeFromTopic('announcement');
                },
                child: const Text('Unsubscribe'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
