import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/user_repository.dart';


class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  StreamSubscription<UserModel> userStream = const Stream<UserModel>.empty().listen((event) {});

  UserCubit(this.userRepository) : super(const UserState());

  FutureOr<void> fetchUser({required String userId}) {
    userStream = userRepository.getUserStream(userId).listen((event) {});
    userStream.onData((data) {
      emit(state.copyWith(userModel: data));
    });
  }
}

class UserState extends Equatable {
  final UserModel? userModel;

  const UserState({
    this.userModel,
  });

  UserState copyWith({
    UserModel? userModel,
  }) {
    return UserState(
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [userModel];
}
