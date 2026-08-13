import 'package:equatable/equatable.dart';

abstract class BookmarkListEvent extends Equatable {
  const BookmarkListEvent();

  @override
  List<Object> get props => [];
}

class FetchBookmarksEvent extends BookmarkListEvent {
  final bool isRefresh;

  const FetchBookmarksEvent({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class LoadMoreBookmarksEvent extends BookmarkListEvent {}
