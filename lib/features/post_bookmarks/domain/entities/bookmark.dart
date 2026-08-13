import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final String userId;
  final String postId;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, userId, postId, createdAt];
}
