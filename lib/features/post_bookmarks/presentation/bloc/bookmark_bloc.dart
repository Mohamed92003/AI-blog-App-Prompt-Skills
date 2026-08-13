import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/toggle_bookmark_usecase.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final ToggleBookmarkUseCase toggleBookmarkUseCase;
  
  // Keep track of processing requests to prevent duplicate network calls (debouncing/throttling logic)
  final Set<String> _processingPosts = {};

  BookmarkBloc({required this.toggleBookmarkUseCase}) : super(BookmarkInitial()) {
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    if (_processingPosts.contains(event.postId)) {
      return; // Debounce/Throttle: Ignore if already processing this post
    }
    
    _processingPosts.add(event.postId);

    // 1. Optimistic update
    emit(BookmarkToggling(postId: event.postId));
    
    final saveIntention = !event.isCurrentlySaved;

    // 2. Perform actual network call
    final result = await toggleBookmarkUseCase(
      params: ToggleBookmarkParams(
        postId: event.postId,
        save: saveIntention,
      ),
    );

    _processingPosts.remove(event.postId);

    // 3. Resolve result
    result.fold(
      (failure) {
        emit(BookmarkToggleError(
          postId: event.postId,
          message: failure.message,
          revertToSaved: event.isCurrentlySaved,
        ));
      },
      (_) {
        emit(BookmarkToggleSuccess(
          postId: event.postId,
          isSaved: saveIntention,
        ));
      },
    );
  }
}
