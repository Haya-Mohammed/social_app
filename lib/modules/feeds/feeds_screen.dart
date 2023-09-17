import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.isNotEmpty,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const Image(
                        image: NetworkImage(
                            'https://img.freepik.com/free-photo/portrait-confused-young-pretty-curly-woman-with-gathered-hair-biting-worringly-underlip-while-looking-perplexedly-front-standing-blue-wall_295783-11247.jpg?t=st=1694165476~exp=1694166076~hmac=ef158998c477ffe6721de2d7fc0ed95efd762109c3a0dcb6a700bd93067ec749'),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildPostItem(
                    SocialCubit.get(context).posts[index],
                    SocialCubit.get(context).userModel!,
                    context,
                    index,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: SocialCubit.get(context).posts.length,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget buildPostItem(PostModel model, UserModel userModel, context, index) =>
    Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    model.image,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      const SizedBox(height: 3),
                      Text(
                        model.dateTime,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz_outlined,
                    size: 20,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 25,
              thickness: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.text,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsetsDirectional.only(end: 6.0),
                //       child: TextButton(
                //         onPressed: () {},
                //         style: TextButton.styleFrom(
                //           padding: EdgeInsets.zero,
                //           alignment: Alignment.centerLeft,
                //         ),
                //         child: const Text('#Software'),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsetsDirectional.only(end: 6.0),
                //       child: TextButton(
                //         onPressed: () {},
                //         style: TextButton.styleFrom(
                //           padding: EdgeInsets.zero,
                //           alignment: Alignment.centerLeft,
                //         ),
                //         child: const Text('#Flutter'),
                //       ),
                //     ),
                //   ],
                // ),
                if (model.postImage != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          image: NetworkImage(model.postImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(SocialCubit.get(context).likes[index].toString()),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                IconBroken.Chat,
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text('0 comments'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 10,
              thickness: 2,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    userModel.image,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(
                        'write a comment ...',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context).postsId[index];
                  },
                  child: const Row(
                    children: [
                      Icon(
                        IconBroken.Heart,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text('Like'),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
