import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:blog_app/features/post_bookmarks/domain/entities/bookmark.dart';
import 'package:blog_app/features/post_bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:blog_app/features/post_bookmarks/domain/usecases/toggle_bookmark_usecase.dart';

class MockBookmarkRepository extends Mock implements BookmarkRepository {}

void main() {
  late ToggleBookmarkUseCase usecase;
  late MockBookmarkRepository mockBookmarkRepository;

  setUp(() {
    mockBookmarkRepository = MockBookmarkRepository();
    usecase = ToggleBookmarkUseCase(mockBookmarkRepository);
  });

  const tPostId = 'test-post-id';
  final tBookmark = Bookmark(
    id: '1',
    userId: 'user1',
    postId: tPostId,
    createdAt: DateTime.now(),
  );

  test('should call addBookmark when action is save', () async {
    // arrange
    when(() => mockBookmarkRepository.addBookmark(any()))
        .thenAnswer((_) async => Right(tBookmark));
    
    // act
    final result = await usecase(params: const ToggleBookmarkParams(postId: tPostId, save: true));
    
    // assert
    expect(result, Right(tBookmark));
    verify(() => mockBookmarkRepository.addBookmark(tPostId));
    verifyNoMoreInteractions(mockBookmarkRepository);
  });

  test('should call removeBookmark when action is not save', () async {
    // arrange
    when(() => mockBookmarkRepository.removeBookmark(any()))
        .thenAnswer((_) async => const Right(null));
    
    // act
    final result = await usecase(params: const ToggleBookmarkParams(postId: tPostId, save: false));
    
    // assert
    expect(result, const Right(null));
    verify(() => mockBookmarkRepository.removeBookmark(tPostId));
    verifyNoMoreInteractions(mockBookmarkRepository);
  });
}
