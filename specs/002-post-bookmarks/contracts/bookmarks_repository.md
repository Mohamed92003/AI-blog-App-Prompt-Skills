# Contracts: Bookmarks Repository

## Interface `BookmarksRepository`

This interface belongs to the `domain/repositories/` layer and defines the contract for interacting with bookmark data.

### Methods

#### `toggleBookmark`
Toggles the bookmark status of a given post for the current user.
- **Parameters**: 
  - `postId` (String): The ID of the post to bookmark/unbookmark.
- **Returns**: `Future<Either<Failure, bool>>`
  - Returns `Right(true)` if bookmarked, `Right(false)` if unbookmarked.
  - Returns `Left(Failure)` on error.

#### `getBookmarkedPosts`
Fetches a paginated list of posts bookmarked by the current user.
- **Parameters**:
  - `page` (int): The page number (for infinite scrolling, 20 items per page).
- **Returns**: `Future<Either<Failure, List<Post>>>`
  - Returns a list of `Post` entities (where `isBookmarked` is true, or placeholder if deleted).
  - Returns `Left(Failure)` on error.

## Interface `BookmarksDataSource`

This interface belongs to the `data/datasources/` layer.

### Methods

#### `toggleBookmark`
- **Parameters**: 
  - `postId` (String).
- **Returns**: `Future<bool>`
- **Throws**: `ServerException` if the Supabase request fails.

#### `getBookmarkedPosts`
- **Parameters**:
  - `page` (int).
- **Returns**: `Future<List<PostModel>>`
- **Throws**: `ServerException` if the Supabase request fails.
