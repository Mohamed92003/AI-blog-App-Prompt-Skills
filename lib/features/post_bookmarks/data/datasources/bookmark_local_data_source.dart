abstract class BookmarkLocalDataSource {
  Future<void> cacheBookmarkedPostIds(List<String> postIds);
  Future<List<String>> getCachedBookmarkedPostIds();
  Future<void> addCachedBookmarkedPostId(String postId);
  Future<void> removeCachedBookmarkedPostId(String postId);
  Future<void> clearCache();
}
