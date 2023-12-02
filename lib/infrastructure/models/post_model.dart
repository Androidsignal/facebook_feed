import 'package:news_feed_flutter/infrastructure/models/comments_model.dart';
import 'package:news_feed_flutter/infrastructure/models/model.dart';
import 'package:news_feed_flutter/infrastructure/models/reactions_model.dart';

class PostModel extends Model {
  final String id;
  final String content;
  final String userId;
  final int totalComment;
  final int likes;
  final int shares;
  final DateTime createdTime;
  final List images;
  final List<CommentsModel>? comments;
  ReactionsModel? reactions;

  PostModel({
    required this.id,
    required this.createdTime,
    this.content = '',
    this.userId = '',
    this.totalComment = 0,
    this.likes = 0,
    this.shares = 0,
    this.images = const [],
    this.comments,
    this.reactions,
  });

  PostModel copyWith({
    String? id,
    String? content,
    String? userId,
    int? totalComment,
    int? likes,
    int? shares,
    DateTime? createdTime,
    List? images,
    List<CommentsModel>? comments,
    ReactionsModel? reactions,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      totalComment: totalComment ?? this.totalComment,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
      createdTime: createdTime ?? this.createdTime,
      images: images ?? this.images,
      comments: comments ?? this.comments,
      reactions: reactions ?? this.reactions,
    );
  }

  PostModel fromJson(Map map) {
    return PostModel(
      id: stringFromJson(map, 'id', defaultVal: '')!,
      content: stringFromJson(map, 'content', defaultVal: '')!,
      userId: stringFromJson(map, 'userId', defaultVal: '')!,
      totalComment: intFromJson(map, 'totalComment', defaultVal: 0)!,
      likes: intFromJson(map, 'likes', defaultVal: 0)!,
      shares: intFromJson(map, 'shares', defaultVal: 0)!,
      createdTime: dateFromJson(map, 'createdTime', defaultVal: DateTime.now())!,
      images: listFromJson(map, 'images'),
      comments: CommentsModel.fromJsonList(listFromJson(map, 'socialLinks')),
      reactions: isNotNull(map['reactions']) ? ReactionsModel(id: '', reactTime: DateTime.now()).fromJson(map['reactions'] ?? {}) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'totalComment': totalComment,
      'likes': likes,
      'shares': shares,
      'createdTime': createdTime,
      'images': images,
      'comments': comments,
      'reactions': reactions,
    };
  }
}
