import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/post_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/user_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_bloc.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_event.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/user_cubit.dart';
import 'package:news_feed_flutter/ui/view/profile_page/profile_page.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../infrastructure/models/post_model.dart';
import '../../../../infrastructure/repository/firestore_repository.dart';
import '../../../common/keep_alive_page.dart';
import '../../comment_page/comment_page.dart';
import '../../reaction_widget.dart';

class PostWidget extends StatelessWidget {
  final PostModel postModel;

  const PostWidget({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(context.read<UserRepository>())..fetchUser(userId: postModel.userId),
      child: PostPage(postModel: postModel),
    );
  }
}

class PostPage extends StatelessWidget {
  final PostModel postModel;

  const PostPage({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? date = DateFormat('EEEE, MMM d, yyyy').format(postModel.createdTime);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(userModel: state.userModel ?? UserModel()),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      state.userModel?.avtar ?? 'https://t3.ftcdn.net/jpg/02/95/26/46/360_F_295264675_clwKZxogAhxLS9sD163Tgkz1WMHsq1RJ.jpg',
                    ),
                  ),
                  subtitle: Text(date, style: context.caption),
                  title: Text(state.userModel?.name ?? '', style: context.titleSmall),
                  trailing: Image.asset('assets/more.png', height: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(postModel.content),
              ),
              const SizedBox(height: 10),
              Container(
                height: (postModel.images.length >= 3) ? height / 2.2 : width / 2,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3.0, offset: Offset(0.0, 2.0)),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: (postModel.images.length == 3 || postModel.images.length == 4) ? Axis.vertical : Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postModel.images.length,
                  itemBuilder: (context, index) {
                    List lastImg = postModel.images;

                    if (postModel.images.length == 3) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            postModel.images.first,
                            height: width,
                            width: width / 2.05,
                            fit: BoxFit.cover,
                          ),
                          const VerticalDivider(width: 4),
                          Column(
                            children: List.generate(
                              lastImg.length - 1,
                              (inx) => Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Image.network(
                                    lastImg[inx + 1],
                                    height: width / 2,
                                    width: width / 2.05,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (postModel.images.length == 4) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              Image.network(
                                lastImg[0],
                                height: width / 2,
                                width: width / 2.05,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 5),
                              Image.network(
                                lastImg[1],
                                height: width / 2,
                                width: width / 2.05,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const VerticalDivider(width: 5),
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              Image.network(
                                lastImg[2],
                                height: width / 2,
                                width: width / 2.05,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 5),
                              Image.network(
                                lastImg[3],
                                height: width / 2,
                                width: width / 2.05,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Image.network(
                            postModel.images[index],
                            width: postModel.images.length == 1 ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2.05,
                            height: MediaQuery.of(context).size.width / 2,
                            fit: BoxFit.cover,
                          ),
                          if (index < postModel.images.length - 1) const SizedBox(width: 5), // Adjust spacing
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Image.asset('assets/like.png', height: 20, width: 20),
                    const SizedBox(width: 10),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('posts/${postModel.id}/reactions').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data?.docs.length ?? 0}');
                        } else {
                          return const Text('0');
                        }
                      },
                    ),
                    const Spacer(),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('posts').doc(postModel.id).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          PostModel post = PostModel(id: '', createdTime: DateTime.now()).fromJson(snapshot.data?.data() as Map<String, dynamic>);
                          return Text('${post.shares}');
                        } else {
                          return const Text('0');
                        }
                      },
                    ),
                    const SizedBox(width: 5),
                    Text('Shares', style: context.caption),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReactionWidget(postModel: postModel),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              postModel: postModel,
                              userModel: state.userModel ?? UserModel(),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/comment.png', height: 20, width: 20),
                          const SizedBox(width: 10),
                          Text('Comment', style: context.caption),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        context.read<HomeBloc>().add(ShareCountUpdate(postId: postModel.id));
                        await Share.share('www.example.com/${postModel.id} \n\n Hi, I am Angelia,i add new post in $date, Bio: ${postModel.content}', subject: 'Bio: ${postModel.content}');
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/share.png', height: 20, width: 20),
                          const SizedBox(width: 10),
                          Text('Share', style: context.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
