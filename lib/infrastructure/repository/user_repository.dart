import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';

class UserRepository {
  final FirestoreRepository firestoreRepository;

  UserRepository(this.firestoreRepository);

  User? get user {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserModel> getUser(String id) async {
    var user = await firestoreRepository.documentFuture(
      path: 'users/$id',
      builder: (Map<String, dynamic>? data, String documentId, {ref}) {
        return UserModel().fromJson(
          data ?? {},
        );
      },
      onError: (error) {
        throw error;
      },
    );
    return user;
  }

  Stream<UserModel> getUserStream(String uid) {
    String path = 'users/$uid';
    return firestoreRepository.documentStream(
        path: path,
        builder: (data, documentID, {ref}) {
          return UserModel().fromJson(
            data,
          );
        },
        onError: (error) {
          throw error;
        });
  }
}
