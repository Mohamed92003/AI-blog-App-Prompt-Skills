import '../models/bookmark_model.dart';

abstract class BookmarkRemoteDataSource {
  Future<BookmarkModel> addBookmark(String postId);
  Future<void> removeBookmark(String postId);
  Future<List<BookmarkModel>> getBookmarks({required int page, required int limit});
}
