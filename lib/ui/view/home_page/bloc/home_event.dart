import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class OnFetchList extends HomeEvent {
  final List<PostModel> list;
  final DocumentSnapshot? lastDoc;

  const OnFetchList({this.list = const [], this.lastDoc});

  @override
  List<Object?> get props => [list, lastDoc];
}

class FetchMatchList extends HomeEvent {
  final bool isRefresh;

  const FetchMatchList({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class FetchMoreMatchList extends HomeEvent {
  const FetchMoreMatchList();

  @override
  List<Object> get props => [];
}

class SendComments extends HomeEvent {
  final String comment;
  final String id;

  const SendComments({this.comment = 'good', this.id = ''});

  @override
  List<Object> get props => [comment, id];
}

class ChangeReaction extends HomeEvent {
  final bool removeLike;
  final ReactionsModel? reactionsModel;
  final String postId;

  const ChangeReaction({
    this.removeLike = false,
    this.reactionsModel,
    this.postId = '',
  });

  @override
  List<Object> get props => [
        removeLike,
        reactionsModel ??
            ReactionsModel(
              id: '',
              reactTime: DateTime.now(),
            ),
        postId,
      ];
}

class ShareCountUpdate extends HomeEvent {
  final String postId;

  const ShareCountUpdate({
    this.postId = '',
  });

  @override
  List<Object> get props => [
        postId,
      ];
}
