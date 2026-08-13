import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/post_bookmarks/domain/entities/bookmark.dart';
import 'package:blog_app/features/post_bookmarks/domain/usecases/get_bookmarked_posts_usecase.dart';
import 'package:blog_app/features/post_bookmarks/presentation/bloc/bookmark_list_bloc.dart';
import 'package:blog_app/features/post_bookmarks/presentation/bloc/bookmark_list_event.dart';
import 'package:blog_app/features/post_bookmarks/presentation/bloc/bookmark_list_state.dart';

class MockGetBookmarkedPostsUseCase extends Mock implements GetBookmarkedPostsUseCase {}

void main() {
  late BookmarkListBloc bloc;
  late MockGetBookmarkedPostsUseCase mockGetBookmarkedPostsUseCase;

  setUp(() {
    mockGetBookmarkedPostsUseCase = MockGetBookmarkedPostsUseCase();
    bloc = BookmarkListBloc(getBookmarkedPostsUseCase: mockGetBookmarkedPostsUseCase);
    
    registerFallbackValue(const GetBookmarkedPostsParams(page: 1));
  });

  final tBookmarks = [
    Bookmark(id: '1', userId: 'u1', postId: 'p1', createdAt: DateTime.now()),
  ];

  test('initial state should be BookmarkListInitial', () {
    expect(bloc.state, BookmarkListInitial());
  });

  blocTest<BookmarkListBloc, BookmarkListState>(
    'should emit [BookmarkListLoading, BookmarkListLoaded] when data is gotten successfully',
    build: () {
      when(() => mockGetBookmarkedPostsUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => Right(tBookmarks));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchBookmarksEvent()),
    expect: () => [
      BookmarkListLoading(),
      BookmarkListLoaded(bookmarks: tBookmarks, hasReachedMax: true),
    ],
  );

  blocTest<BookmarkListBloc, BookmarkListState>(
    'should emit [BookmarkListLoading, BookmarkListError] when getting data fails',
    build: () {
      when(() => mockGetBookmarkedPostsUseCase(params: any(named: 'params')))
          .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchBookmarksEvent()),
    expect: () => [
      BookmarkListLoading(),
      const BookmarkListError('Server Error'),
    ],
  );
}
