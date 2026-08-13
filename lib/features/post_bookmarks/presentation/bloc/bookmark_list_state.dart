import 'package:equatable/equatable.dart';
import '../../domain/entities/bookmark.dart';

abstract class BookmarkListState extends Equatable {
  const BookmarkListState();

  @override
  List<Object?> get props => [];
}

class BookmarkListInitial extends BookmarkListState {}

class BookmarkListLoading extends BookmarkListState {}

class BookmarkListLoaded extends BookmarkListState {
  final List<Bookmark> bookmarks;
  final bool hasReachedMax;

  const BookmarkListLoaded({
    required this.bookmarks,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [bookmarks, hasReachedMax];

  BookmarkListLoaded copyWith({
    List<Bookmark>? bookmarks,
    bool? hasReachedMax,
  }) {
    return BookmarkListLoaded(
      bookmarks: bookmarks ?? this.bookmarks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class BookmarkListError extends BookmarkListState {
  final String message;

  const BookmarkListError(this.message);

  @override
  List<Object> get props => [message];
}
