import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:tuple/tuple.dart';

class PostRepository {
  final FirestoreRepository firestoreRepository;

  PostRepository(this.firestoreRepository);

  Stream<Tuple4> getStreamPost({
    DocumentSnapshot? lastDoc,
  }) {
    return firestoreRepository.collectionGroupStreamWithOptions(
      path: 'posts',
      queryBuilder: (query) {
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
        return query.limit(3);
      },
      builder: (data, ref) => PostModel(id: '', createdTime: DateTime.now()).fromJson(data ?? {}),
      changedBuilder: (data, ref) => PostModel(id: '', createdTime: DateTime.now()).fromJson(data ?? {}),
      removedBuilder: (data, ref) => PostModel(id: '', createdTime: DateTime.now()).fromJson(data ?? {}),
    );
  }

  Stream<ReactionsModel> getMyReaction(String postId) {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    return firestoreRepository.documentStream(
      path: 'posts/$postId/reactions/$myId',
      builder: (data, documentID, {ref}) {
        return ReactionsModel(
          id: documentID,
          reactTime: DateTime.now(),
        ).fromJson(data);
      },
      onError: (error) {
        debugPrint('$error');
      },
    );
  }

  Future<DocumentReference> setMyReaction(String postId, ReactionsModel reactionsModel) {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    return firestoreRepository.setData(
      path: 'posts/$postId/reactions/$myId',
      data: reactionsModel.toJson(),
    );
  }

  Future removeMyReaction(String postId) {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    return firestoreRepository.deleteData(path: 'posts/$postId/reactions/$myId');
  }

  Future updateReactionCount(String postId, bool isIncrease) {
    return firestoreRepository.updateData(
      path: 'posts/$postId',
      data: {
        'likes': FieldValue.increment(isIncrease ? 1 : -1),
      },
    );
  }

  Future updateSharesCount(String postId) {
    return firestoreRepository.updateData(
      path: 'posts/$postId',
      data: {
        'shares': FieldValue.increment(1),
      },
    );
  }
}
