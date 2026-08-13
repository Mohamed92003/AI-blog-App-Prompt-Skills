import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/post_bookmarks/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:blog_app/features/post_bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blog_app/features/post_bookmarks/presentation/bloc/bookmark_event.dart';
import 'package:blog_app/features/post_bookmarks/presentation/bloc/bookmark_state.dart';

class MockToggleBookmarkUseCase extends Mock implements ToggleBookmarkUseCase {}

void main() {
  late BookmarkBloc bloc;
  late MockToggleBookmarkUseCase mockToggleBookmarkUseCase;

  setUp(() {
    mockToggleBookmarkUseCase = MockToggleBookmarkUseCase();
    bloc = BookmarkBloc(toggleBookmarkUseCase: mockToggleBookmarkUseCase);
    
    // Register fallback value for Mocktail
    registerFallbackValue(const ToggleBookmarkParams(postId: 'fallback', save: true));
  });

  const tPostId = 'test-post-id';

  test('initial state should be BookmarkInitial', () {
    expect(bloc.state, BookmarkInitial());
  });

  blocTest<BookmarkBloc, BookmarkState>(
    'should emit [BookmarkToggling, BookmarkToggleSuccess] when toggle is successful',
    build: () {
      when(() => mockToggleBookmarkUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(const ToggleBookmarkEvent(postId: tPostId, isCurrentlySaved: false)),
    expect: () => [
      const BookmarkToggling(postId: tPostId),
      const BookmarkToggleSuccess(postId: tPostId, isSaved: true),
    ],
  );

  blocTest<BookmarkBloc, BookmarkState>(
    'should emit [BookmarkToggling, BookmarkToggleError] when toggle fails',
    build: () {
      when(() => mockToggleBookmarkUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const ToggleBookmarkEvent(postId: tPostId, isCurrentlySaved: true)),
    expect: () => [
      const BookmarkToggling(postId: tPostId),
      const BookmarkToggleError(postId: tPostId, message: 'Server Error', revertToSaved: true),
    ],
  );
}
