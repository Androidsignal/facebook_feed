import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/post_repository.dart';


class ReactionCubit extends Cubit<ReactionState> {
  final PostRepository postRepository;

  StreamSubscription<ReactionsModel> reactionStream = const Stream<ReactionsModel>.empty().listen((event) {});

  ReactionCubit(this.postRepository) : super(const ReactionState());

  FutureOr<void> fetchReaction({required String postId}) {
    reactionStream = postRepository.getMyReaction(postId).listen((event) {});
    reactionStream.onData((data) {
      emit(state.copyWith(reactions: data));
    });
  }

  FutureOr<void> updateReaction({
    required String postId,
    required ReactionsModel reactionsModel,
    required bool removeLike,
  }) async {
    if(removeLike){
      await postRepository.removeMyReaction(postId);
    }else {
      final result = await postRepository.setMyReaction(postId, reactionsModel);
      debugPrint(result.path);
    }
     await postRepository.updateReactionCount(postId, !removeLike);
  }
}

class ReactionState extends Equatable {
  final ReactionsModel? reactions;

  const ReactionState({
    this.reactions,
  });

  ReactionState copyWith({
    ReactionsModel? reactions,
  }) {
    return ReactionState(
      reactions: reactions ?? this.reactions,
    );
  }

  @override
  List<Object?> get props => [reactions];
}
