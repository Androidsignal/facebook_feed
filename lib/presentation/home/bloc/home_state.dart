import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final bool isFetchMore;
  final bool isRemoveLike;
  final List<PostModel> posts;
  final DocumentSnapshot? lastDocument;
  final Reaction? selectedReaction;

  const HomeState({
    this.isLoading = true,
    this.isFetchMore = false,
    this.isRemoveLike = false,
    this.posts = const [],
    this.lastDocument,
    this.selectedReaction,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isFetchMore,
    bool? isRemoveLike,
    List<PostModel>? posts,
    DocumentSnapshot? lastDocument,
    Reaction? selectedReaction,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isFetchMore: isFetchMore ?? this.isFetchMore,
      isRemoveLike: isRemoveLike ?? this.isRemoveLike,
      posts: posts ?? this.posts,
      lastDocument: lastDocument ?? this.lastDocument,
      selectedReaction: selectedReaction ?? this.selectedReaction,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isFetchMore,
        isRemoveLike,
        posts,
        lastDocument,
        selectedReaction,
      ];
}
