import 'package:news_feed_flutter/infrastructure/models/model.dart';

class UserModel extends Model {
  final String name;
  final String avtar;
  final String userId;
  final String date_of_birth;

  UserModel({
    this.name = '',
    this.avtar = '',
    this.userId = '',
    this.date_of_birth = '',
  });

  UserModel copyWith({
    String? name,
    String? avtar,
    String? userId,
    String? date_of_birth,
  }) {
    return UserModel(
      name: name ?? this.name,
      avtar: avtar ?? this.avtar,
      userId: userId ?? this.userId,
      date_of_birth: date_of_birth ?? this.date_of_birth,
    );
  }

  UserModel fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: stringFromJson(map, 'name', defaultVal: '')!,
      avtar: stringFromJson(map, 'avtar', defaultVal: '')!,
      userId: stringFromJson(map, 'userId', defaultVal: '')!,
      date_of_birth: stringFromJson(map, 'date_of_birth', defaultVal: '')!,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avtar': avtar,
      'userId': userId,
      'date_of_birth':date_of_birth,
    };
  }
}
