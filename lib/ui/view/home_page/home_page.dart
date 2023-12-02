import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/ui/common/keep_alive_page.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_bloc.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_event.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_state.dart';
import 'package:news_feed_flutter/ui/view/post_user_widget.dart';
import 'package:news_feed_flutter/ui/view/reaction_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../comment_page/comment_page.dart';
import 'widget/post_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = context.read<HomeBloc>();

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
      appBar: AppBar(
        title: Image.asset('assets/fb_logo.png', height: 60),
        centerTitle: false,
        elevation: 2,
        actions: [
          TextButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: Text(
              'Login',
              style: context.bodySmall,
            ),
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
                return PostWidget(
                  postModel: state.posts[index],
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
