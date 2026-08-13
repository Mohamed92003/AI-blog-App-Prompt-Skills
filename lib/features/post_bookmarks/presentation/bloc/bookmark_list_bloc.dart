import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_bookmarked_posts_usecase.dart';
import 'bookmark_list_event.dart';
import 'bookmark_list_state.dart';

class BookmarkListBloc extends Bloc<BookmarkListEvent, BookmarkListState> {
  final GetBookmarkedPostsUseCase getBookmarkedPostsUseCase;
  
  int _currentPage = 1;
  final int _limit = 20;

  BookmarkListBloc({required this.getBookmarkedPostsUseCase}) : super(BookmarkListInitial()) {
    on<FetchBookmarksEvent>(_onFetchBookmarks);
    on<LoadMoreBookmarksEvent>(_onLoadMoreBookmarks);
  }

  Future<void> _onFetchBookmarks(
    FetchBookmarksEvent event,
    Emitter<BookmarkListState> emit,
  ) async {
    if (event.isRefresh) {
      _currentPage = 1;
    } else {
      emit(BookmarkListLoading());
    }

    final result = await getBookmarkedPostsUseCase(
      params: GetBookmarkedPostsParams(page: _currentPage, limit: _limit),
    );

    result.fold(
      (failure) {
        emit(BookmarkListError(failure.message));
      },
      (bookmarks) {
        final hasReachedMax = bookmarks.length < _limit;
        emit(BookmarkListLoaded(
          bookmarks: bookmarks,
          hasReachedMax: hasReachedMax,
        ));
      },
    );
  }

  Future<void> _onLoadMoreBookmarks(
    LoadMoreBookmarksEvent event,
    Emitter<BookmarkListState> emit,
  ) async {
    final currentState = state;
    if (currentState is BookmarkListLoaded && !currentState.hasReachedMax) {
      _currentPage++;
      final result = await getBookmarkedPostsUseCase(
        params: GetBookmarkedPostsParams(page: _currentPage, limit: _limit),
      );

      result.fold(
        (failure) {
          emit(BookmarkListError(failure.message));
        },
        (newBookmarks) {
          emit(currentState.copyWith(
            bookmarks: List.of(currentState.bookmarks)..addAll(newBookmarks),
            hasReachedMax: newBookmarks.length < _limit,
          ));
        },
      );
    }
  }
}
