import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class ToggleBookmarkEvent extends BookmarkEvent {
  final String postId;
  final bool isCurrentlySaved;

  const ToggleBookmarkEvent({
    required this.postId,
    required this.isCurrentlySaved,
  });

  @override
  List<Object> get props => [postId, isCurrentlySaved];
}
