import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkToggling extends BookmarkState {
  final String postId;

  const BookmarkToggling({required this.postId});

  @override
  List<Object> get props => [postId];
}

class BookmarkToggleSuccess extends BookmarkState {
  final String postId;
  final bool isSaved;

  const BookmarkToggleSuccess({required this.postId, required this.isSaved});

  @override
  List<Object> get props => [postId, isSaved];
}

class BookmarkToggleError extends BookmarkState {
  final String postId;
  final String message;
  final bool revertToSaved;

  const BookmarkToggleError({
    required this.postId,
    required this.message,
    required this.revertToSaved,
  });

  @override
  List<Object> get props => [postId, message, revertToSaved];
}
