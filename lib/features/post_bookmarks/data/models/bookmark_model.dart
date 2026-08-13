import '../../domain/entities/bookmark.dart';

class BookmarkModel extends Bookmark {
  const BookmarkModel({
    required super.id,
    required super.userId,
    required super.postId,
    required super.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      postId: json['post_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Bookmark toEntity() {
    return Bookmark(
      id: id,
      userId: userId,
      postId: postId,
      createdAt: createdAt,
    );
  }
}
