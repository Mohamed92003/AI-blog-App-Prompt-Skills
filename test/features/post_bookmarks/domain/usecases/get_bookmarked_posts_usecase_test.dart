import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:blog_app/features/post_bookmarks/domain/entities/bookmark.dart';
import 'package:blog_app/features/post_bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:blog_app/features/post_bookmarks/domain/usecases/get_bookmarked_posts_usecase.dart';

class MockBookmarkRepository extends Mock implements BookmarkRepository {}

void main() {
  late GetBookmarkedPostsUseCase usecase;
  late MockBookmarkRepository mockBookmarkRepository;

  setUp(() {
    mockBookmarkRepository = MockBookmarkRepository();
    usecase = GetBookmarkedPostsUseCase(mockBookmarkRepository);
  });

  final tBookmarks = [
    Bookmark(id: '1', userId: 'u1', postId: 'p1', createdAt: DateTime.now()),
  ];

  test('should get bookmarks from the repository', () async {
    // arrange
    when(() => mockBookmarkRepository.getBookmarks(page: 1, limit: 20))
        .thenAnswer((_) async => Right(tBookmarks));
    
    // act
    final result = await usecase(params: const GetBookmarkedPostsParams(page: 1, limit: 20));
    
    // assert
    expect(result, Right(tBookmarks));
    verify(() => mockBookmarkRepository.getBookmarks(page: 1, limit: 20));
    verifyNoMoreInteractions(mockBookmarkRepository);
  });
}
