import '../../domain/entities/post.dart';

class PostModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final bool isBookmarked;

  const PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.createdAt,
    this.isBookmarked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'author_id': authorId,
        'is_bookmarked': isBookmarked,
      };

  Post toEntity() => Post(
        id: id,
        title: title,
        content: content,
        authorId: authorId,
        createdAt: createdAt,
        isBookmarked: isBookmarked,
      );
}
