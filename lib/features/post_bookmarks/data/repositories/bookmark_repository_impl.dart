import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_data_source.dart';
import '../datasources/bookmark_remote_data_source.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkRemoteDataSource remoteDataSource;
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Bookmark>> addBookmark(String postId) async {
    try {
      final remoteBookmark = await remoteDataSource.addBookmark(postId);
      await localDataSource.addCachedBookmarkedPostId(postId);
      return Right(remoteBookmark.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String postId) async {
    try {
      await remoteDataSource.removeBookmark(postId);
      await localDataSource.removeCachedBookmarkedPostId(postId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarks({required int page, required int limit}) async {
    try {
      final remoteBookmarks = await remoteDataSource.getBookmarks(page: page, limit: limit);
      // Cache the first page for optimistic UI
      if (page == 1) {
        final postIds = remoteBookmarks.map((e) => e.postId).toList();
        await localDataSource.cacheBookmarkedPostIds(postIds);
      }
      return Right(remoteBookmarks.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
