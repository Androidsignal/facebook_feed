import 'package:news_feed_flutter/infrastructure/models/model.dart';

class CommentsModel extends Model {
  final String id;
  final String comment;
  final String userId;
  final String postId;
  final String userName;
  final String userProfile;
  final DateTime commentTime;


  CommentsModel({
    required this.id,
    required this.commentTime,
    this.userId = '',
    this.postId = '',
    this.comment = '',
    this.userProfile = '',
    this.userName = '',

  });

  CommentsModel copyWith({
    String? id,
    String? comment,
    String? postId,
    String? userId,
    String? userName,
    String? userProfile,
    DateTime? commentTime,
  }) {
    return CommentsModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      commentTime: commentTime ?? this.commentTime,
    );
  }

  static List<CommentsModel> fromJsonList(dynamic json) {
    var listData = <CommentsModel>[];
    if (json != null && json is List) {
      for (var element in json) {
        listData.add(CommentsModel(id: '',commentTime: DateTime.now()).fromJson(element));
      }
    }
    return listData;
  }

  CommentsModel fromJson(Map map) {
    return CommentsModel(
      id: stringFromJson(map, 'id', defaultVal: '')!,
      comment: stringFromJson(map, 'comment', defaultVal: '')!,
      userId: stringFromJson(map, 'userId', defaultVal: '')!,
      userName: stringFromJson(map, 'userName', defaultVal: '')!,
      userProfile: stringFromJson(map, 'userProfile', defaultVal: '')!,
      postId: stringFromJson(map, 'postId', defaultVal: '')!,
      commentTime: dateFromJson(map, 'commentTime', defaultVal: DateTime.now())!,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfile': userProfile,
      'commentTime': commentTime,
    };
  }
}
