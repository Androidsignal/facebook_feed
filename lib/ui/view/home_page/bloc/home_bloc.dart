import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed_flutter/infrastructure/models/comments_model.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/post_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/user_repository.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_event.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostRepository postRepository;
  final FirestoreRepository firestoreRepository;
  final UserRepository userRepository;
  StreamSubscription _postStreamSubscription = const Stream.empty().listen((event) {});
  StreamSubscription _userStreamSubscription = const Stream.empty().listen((event) {});
  StreamSubscription? streamSubscription;
  var uID = FirebaseAuth.instance.currentUser?.uid;
  var auth = FirebaseAuth.instance.currentUser;

  HomeBloc({
    required this.postRepository,
    required this.firestoreRepository,
    required this.userRepository,
  }) : super(const HomeState()) {
    on<OnFetchList>(_onFetchList);
    on<FetchMatchList>(_onFetchMatchList);
    on<FetchMoreMatchList>(_onFetchMoreMatchList);
    on<ChangeReaction>(_onChangeReaction);
    on<SendComments>(_onSendComments);
    on<ShareCountUpdate>(_onShareCountUpdate);
  }

  void _fetchData({bool isRefresh = false}) {
    _postStreamSubscription = postRepository.getStreamPost(lastDoc: isRefresh ? null : state.lastDocument).listen((event) {});

    _postStreamSubscription.onData((data) async {
      List<PostModel> list = [];
      if (!isRefresh) {
        list = List.from(state.posts);
      }
      //add items
      if (list.isEmpty || !state.isFetchMore) {
        list.insertAll(0, data.item1.cast<PostModel>());
      } else {
        list.addAll(data.item1.cast<PostModel>());
      }

      //change item
      List<PostModel> changed = data.item2.cast<PostModel>();
      for (int i = 0; i < list.length; i++) {
        int index = changed.indexWhere((element) => element.id == list[i].id);
        if (index > -1) {
          list[i] = changed[index];
        }
      }

      //remove item
      List<PostModel> removed = data.item3.cast<PostModel>();
      list.removeWhere((element) => removed.any((e) => e.id == element.id));

      List<PostModel> distinctList = [];

      for (PostModel item in list) {
        bool exist = distinctList.any((element) => element.id == item.id);
        if (!exist) {
          distinctList.add(item);
        }
      }
      add(OnFetchList(list: distinctList, lastDoc: data.item4));
    });
  }

  FutureOr<void> _onFetchList(OnFetchList event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      posts: event.list,
      isLoading: false,
      isFetchMore: false,
      lastDocument: event.lastDoc,
    ));
  }

  FutureOr<void> _onFetchMatchList(FetchMatchList event, Emitter<HomeState> emit) {
    emit(state.copyWith(isLoading: true, posts: []));
    _fetchData(isRefresh: event.isRefresh);
  }

  FutureOr<void> _onFetchMoreMatchList(FetchMoreMatchList event, Emitter<HomeState> emit) {
    emit(state.copyWith(isFetchMore: true));
    _fetchData();
  }

  Future _onChangeReaction(ChangeReaction event, Emitter<HomeState> emit) async {
    if (!event.removeLike) {
      await postRepository.removeMyReaction(event.postId);
    } else {
      ReactionsModel reactionsModel = ReactionsModel(id: '', reactTime: DateTime.now());
      final result = await postRepository.setMyReaction(event.postId, event.reactionsModel ?? reactionsModel);
      debugPrint(result.path);
    }
    await postRepository.updateReactionCount(event.postId, event.removeLike);
  }

  Future _onSendComments(SendComments event, Emitter<HomeState> emit) async {
    String commentId = '${DateTime.now().millisecondsSinceEpoch}';
    await firestoreRepository.setData(
      path: 'posts/${event.id}/comments/$commentId/',
      data: CommentsModel(id: commentId, postId: event.id, commentTime: DateTime.now(), comment: event.comment, userId: uID ?? '', userName: auth?.displayName ?? '', userProfile: auth?.photoURL ?? '')
          .toJson(),
    );
  }

  Future _onShareCountUpdate(ShareCountUpdate event, Emitter<HomeState> emit) async {
    await _postStreamSubscription.cancel();
    await postRepository.updateSharesCount(event.postId);
  }

  @override
  Future<void> close() async {
    await _postStreamSubscription.cancel();
    await _userStreamSubscription.cancel();
    return super.close();
  }
}
