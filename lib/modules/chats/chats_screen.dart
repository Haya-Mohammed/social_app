import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.isNotEmpty,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildUserItem(
              SocialCubit.get(context).users[index],
              context,
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 0,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            itemCount: SocialCubit.get(context).users.length,
            physics: const BouncingScrollPhysics(),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

Widget buildUserItem(UserModel model, context) => InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatDetails(model),),);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(model.image),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Text(
                    model.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(height: 1.4),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
