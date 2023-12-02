import 'package:news_feed_flutter/infrastructure/models/model.dart';

class ReactionsModel extends Model {
  final String id;
  String reactionId;
  final String userId;
  final DateTime reactTime;

  ReactionsModel({
    required this.id,
    required this.reactTime,
    this.userId = '',
    this.reactionId = '',
  });

  ReactionsModel copyWith({
    String? id,
    String? reactionId,
    String? userId,
    DateTime? reactTime,
  }) {
    return ReactionsModel(
      id: id ?? this.id,
      reactionId: reactionId ?? this.reactionId,
      userId: userId ?? this.userId,
      reactTime: reactTime ?? this.reactTime,
    );
  }

  ReactionsModel fromJson(Map<String, dynamic> map) {
    return ReactionsModel(
      id: stringFromJson(map, 'id', defaultVal: '')!,
      reactionId: stringFromJson(map, 'reactionId', defaultVal: '')!,
      userId: stringFromJson(map, 'userId', defaultVal: '')!,
      reactTime: dateFromJson(map, 'reactTime', defaultVal: DateTime.now())!,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reactionId': reactionId,
      'userId': userId,
      'reactTime': reactTime,
    };
  }
}
