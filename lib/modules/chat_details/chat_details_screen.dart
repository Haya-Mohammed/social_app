import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

class ChatDetails extends StatelessWidget {
  UserModel userModel;
  ChatDetails(this.userModel);

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessage(receiverId: userModel.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userModel.image),
                ),
                const SizedBox(width: 20),
                Text(userModel.name),
              ],
            ),
            titleSpacing: 0.0,
          ),
          body: ConditionalBuilder(
            condition: SocialCubit.get(context).messages.isNotEmpty,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index){
                        var message = SocialCubit.get(context).messages[index];
                        if(SocialCubit.get(context).userModel!.uId == message.senderId){
                          return buildMyMessage(message);
                        }else{
                          return buildMessage(message);
                        }
                      },
                      separatorBuilder: (context, index)=> const SizedBox(height: 10),
                      itemCount: SocialCubit.get(context).messages.length,
                      physics: const BouncingScrollPhysics(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              controller: textController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type your message here ...'),
                            ),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          color: defaultColor,
                          child: MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).sendMessage(
                                receiverId: userModel.uId,
                                dateTime: DateTime.now().toString(),
                                text: textController.text,
                              );
                            },
                            minWidth: 1.0,
                            child: const Icon(
                              IconBroken.Send,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    });
  }

  Widget buildMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Text(model.text),
      ),
    );
  }

  Widget buildMyMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: defaultColor.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
          ),
        ),
        child: Text(model.text),
      ),
    );
  }
}
