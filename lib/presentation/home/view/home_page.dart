import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/presentation/common/keep_alive_page.dart';
import 'package:news_feed_flutter/presentation/common/social_feed_reaction_base.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_bloc.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_event.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_state.dart';
import 'package:news_feed_flutter/presentation/home/bloc/user_cubit.dart';
import 'package:news_feed_flutter/presentation/home/view/post_user_widget.dart';
import 'package:news_feed_flutter/presentation/home/view/profile_page.dart';
import 'package:news_feed_flutter/presentation/home/view/reaction_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import 'comment_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Reaction<String> defaultReaction = Reaction<String>(
    title: const Text('Like'),
    value: 'empty_like',
    icon: Image.asset('assets/images/ic_like.png', height: 25),
  );

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey();
    HomeBloc homeBloc = context.read<HomeBloc>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    void onRefresh(HomeBloc bloc) {
      bloc.add(const FetchMatchList(isRefresh: true));
      refreshController.refreshCompleted();
    }

    void pullUpToLoad() {
      if (context.mounted) {
        homeBloc.add(const FetchMoreMatchList());
      }
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          TextButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: const Text('Login'),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => previous.isFetchMore != current.isFetchMore || previous.posts != current.posts,
        listener: (context, state) {
          if (!state.isFetchMore) {
            refreshController.loadComplete();
          }
        },
        buildWhen: (previous, current) => previous.isLoading != current.isLoading || previous.isFetchMore != current.isFetchMore || previous.posts != current.posts,
        builder: (context, state) {
          return SmartRefresher(
            enablePullUp: true,
            primary: false,
            header: const WaterDropMaterialHeader(),
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                switch (mode) {
                  case LoadStatus.idle:
                    body = const Text('Pull up to load more');
                    break;
                  case LoadStatus.loading:
                    body = const CircularProgressIndicator();
                    break;
                  case LoadStatus.failed:
                    body = const Text('Load Failed! Click retry!');
                    break;
                  default:
                    body = const Text('No more matches');
                    break;
                }
                return SizedBox(
                  height: 55,
                  child: Center(child: body),
                );
              },
            ),
            controller: refreshController,
            onRefresh: () {
              HapticFeedback.lightImpact();
              onRefresh(homeBloc);
            },
            onLoading: () {
              HapticFeedback.lightImpact();
              pullUpToLoad();
            },
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemCount: state.posts.length,
              separatorBuilder: (BuildContext context, int index) => Divider(thickness: 10, color: Colors.grey.shade200),
              itemBuilder: (BuildContext context, int index) {
                PostModel postModel = state.posts[index];
                String? date = DateFormat('EEEE, MMM d, yyyy').format(postModel.createdTime);
                return KeepAlivePage(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostUserWidget(postModel: postModel),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(postModel.content),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: (postModel.images.length >= 3) ? height / 2.2 : width / 2,
                          child: ListView.builder(
                            scrollDirection: (postModel.images.length == 3 || postModel.images.length == 4) ? Axis.vertical : Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: postModel.images.length,
                            itemBuilder: (context, index) {
                              if (postModel.images.length == 3) {
                                var img = postModel.images.first;
                                List lastImg = postModel.images;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (index == 0)
                                      Image.network(
                                        img,
                                        height: width,
                                        width: width / 2.05,
                                        fit: BoxFit.cover,
                                      ),
                                    const VerticalDivider(width: 5),
                                    if (index == 0)
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
                                List lastImg = postModel.images;

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
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Image.asset('assets/like.png', height: 20, width: 20),
                              const SizedBox(width: 10),
                              Text('${postModel.likes}'),
                              const Spacer(),
                              Text('${postModel.shares}'),
                              const SizedBox(width: 5),
                              Text('Shares', style: context.caption),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      builder: (context) => CommentPage(postModel: postModel),
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
                                  await Share.share('www.example.com/${postModel.id} \n\n Hi, I am Angelia,i add new post in $date, Bio: ${postModel.content}', subject: 'Bio: ${postModel.content}');
                                  await FirestoreRepository().updateData(path: 'posts/${postModel.id}', data: {'shares': FieldValue.increment(1)});
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
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = authResult.user;
      UserModel userModel = UserModel(
        userId: user!.uid,
        name: user.displayName ?? '',
        avtar: user.photoURL ?? "",
      );
      await FirestoreRepository().setData(
        path: 'users/${user.uid}',
        data: userModel.toJson(),
      );
      return authResult;
    } catch (e) {
      debugPrint('Exception in signInWithGoogle : $e');
    }
    return null;
  }
}
