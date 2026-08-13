import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bookmark.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, Bookmark>> addBookmark(String postId);
  Future<Either<Failure, void>> removeBookmark(String postId);
  Future<Either<Failure, List<Bookmark>>> getBookmarks({required int page, required int limit});
}
