import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/post_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/reaction_cubit.dart';

// class ReactionWidget extends StatelessWidget {
//   final PostModel postModel;
//
//   const ReactionWidget({Key? key, required this.postModel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: ReactionCubit(context.read<PostRepository>())..fetchReaction(postId: postModel.id),
//       // create: (context) => ReactionCubit(context.read<PostRepository>())..fetchReaction(postId: postModel.id),
//       child: ReactionScreen(postModel: postModel),
//     );
//   }
// }

class ReactionWidget extends StatelessWidget {
  final PostModel postModel;

  ReactionWidget({Key? key, required this.postModel}) : super(key: key);

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts/${postModel.id}/reactions').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print("Data : ${snapshot.data?.data() ?? {}}");
          if ((snapshot.data?.data()?.isEmpty ?? false) || snapshot.data?.data() == null) {
            return GestureDetector(
              onTap: () async {
                final result = await PostRepository(context.read<FirestoreRepository>(),).setMyReaction(
                  postModel.id,
                  ReactionsModel(
                    id: postModel.id,
                    reactTime: DateTime.now(),
                    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                    reactionId: 'like',
                  ),
                );
                // await FirestoreRepository().updateData(
                //   path: 'posts/${postModel.id}',
                //   data: {
                //     'likes': FieldValue.increment(1),
                //   },
                // );
              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_like.png',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text('Like'),
                ],
              ),
            );
          } else {
            ReactionsModel reactionsModel = ReactionsModel(id: '', reactTime: DateTime.now()).fromJson(snapshot.data?.data() as Map<String, dynamic>);
            return GestureDetector(
              onTap: () async {
                final result = await PostRepository(
                  context.read<FirestoreRepository>(),
                ).removeMyReaction(
                  postModel.id,
                );
                // await FirestoreRepository().updateData(
                //   path: 'posts/${postModel.id}',
                //   data: {
                //     'likes': FieldValue.increment(-1),
                //   },
                // );
              },
              child: Row(
                children: [
                  Image.asset(
                    reactionsModel.reactionId.isEmpty ? 'assets/images/ic_like.png' : 'assets/images/ic_like_fill.png',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text('Like'),
                ],
              ),
            );
          }
        } else {
          return Row(
            children: [
              Image.asset(
                'assets/images/ic_like.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 10),
              const Text('Like'),
            ],
          );
        }
      },
    );
    // return BlocBuilder<ReactionCubit, ReactionState>(
    //   buildWhen: (previous, current) => previous.reactions != current.reactions,
    //   builder: (context, state) {
    //     ReactionsModel? reactionsModel = state.reactions;
    //     String reactionId = reactionsModel?.reactionId ?? '';
    //     Reaction reaction = reactionId.geReaction;
    //     return GestureDetector(
    //       onTap: () {
    //         context.read<ReactionCubit>().updateReaction(
    //               postId: postModel.id,
    //               reactionsModel: ReactionsModel(
    //                 id: postModel.id,
    //                 reactTime: DateTime.now(),
    //                 userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    //                 reactionId: reactionId.isEmpty ? 'like' : '',
    //               ),
    //               removeLike: reactionId.isEmpty ? false : true,
    //             );
    //       },
    //       child: Row(
    //         children: [
    //           reaction.icon,
    //           const SizedBox(width: 10),
    //           reaction.title!,
    //         ],
    //       ),
    //     );
    //     return ReactionButton(
    //       animateBox: true,
    //       toggle: true,
    //       onReactionChanged: (value) {
    //         bool sameReaction = value != null && value.value == reaction.value;
    //         context.read<ReactionCubit>().updateReaction(
    //               postId: postModel.id,
    //               reactionsModel: ReactionsModel(
    //                 id: postModel.id,
    //                 reactTime: DateTime.now(),
    //                 userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    //                 reactionId: value?.value ?? '',
    //               ),
    //               removeLike: value?.value == null || value?.value == 'empty_like' || sameReaction,
    //             );
    //       },
    //       reactions: <Reaction<String>>[
    //         Reaction<String>(
    //           title: const Text('Like'),
    //           value: 'like',
    //           icon: Image.asset('assets/images/ic_like_fill.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Angry'),
    //           value: 'angry',
    //           icon: Image.asset('assets/images/angry.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Happy'),
    //           value: 'happy',
    //           icon: Image.asset('assets/images/happy.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Love'),
    //           value: 'love',
    //           icon: Image.asset('assets/images/in-love.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Mad'),
    //           value: 'mad',
    //           icon: Image.asset('assets/images/mad.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Sad'),
    //           value: 'sad',
    //           icon: Image.asset('assets/images/sad.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Smile'),
    //           value: 'smile',
    //           icon: Image.asset('assets/images/smile.png', height: 25),
    //         ),
    //         Reaction<String>(
    //           title: const Text('Surprised'),
    //           value: 'surprised',
    //           icon: Image.asset('assets/images/surprised.png', height: 25),
    //         ),
    //       ],
    //       itemSize: const Size(25, 25),
    //       child: Row(
    //         children: [
    //           reaction.icon,
    //           const SizedBox(width: 10),
    //           reaction.title!,
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}

extension GetReactionModel on String {
  Reaction get geReaction {
    switch (this) {
      case 'like':
        return Reaction<String>(
          title: const Text('Like'),
          value: 'like',
          icon: Image.asset('assets/images/ic_like_fill.png', height: 25),
        );
      case 'angry':
        return Reaction<String>(
          title: const Text('Angry'),
          value: 'angry',
          icon: Image.asset('assets/images/angry.png', height: 25),
        );
      case 'happy':
        return Reaction<String>(
          title: const Text('Happy'),
          value: 'happy',
          icon: Image.asset('assets/images/happy.png', height: 25),
        );
      case 'love':
        return Reaction<String>(
          title: const Text('Love'),
          value: 'love',
          icon: Image.asset('assets/images/in-love.png', height: 25),
        );
      case 'mad':
        return Reaction<String>(
          title: const Text('Mad'),
          value: 'mad',
          icon: Image.asset('assets/images/mad.png', height: 25),
        );
      case 'sad':
        return Reaction<String>(
          title: const Text('Sad'),
          value: 'sad',
          icon: Image.asset('assets/images/sad.png', height: 25),
        );
      case 'smile':
        return Reaction<String>(
          title: const Text('Smile'),
          value: 'smile',
          icon: Image.asset('assets/images/smile.png', height: 25),
        );
      case 'surprised':
        return Reaction<String>(
          title: const Text('Surprised'),
          value: 'surprised',
          icon: Image.asset('assets/images/surprised.png', height: 25),
        );
      default:
        return Reaction<String>(
          title: const Text('Like'),
          value: 'empty_like',
          icon: Image.asset('assets/images/ic_like.png', height: 25),
        );
    }
  }
}
