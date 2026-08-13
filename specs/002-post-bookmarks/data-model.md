# Data Model: Post Bookmarks

## Entities

### `Bookmark` (Domain Entity)
Represents a link between a User and a Post.
- `id` (String): Unique identifier.
- `userId` (String): The user who bookmarked the post.
- `postId` (String): The post that was bookmarked.
- `createdAt` (DateTime): Timestamp of when the bookmark was created.

### `Post` (Domain Entity - Extended)
Represents a blog post entity, extended with bookmark context.
- `id` (String): Unique identifier.
- `title` (String): Post title.
- `content` (String): Post content/body.
- `authorId` (String): Author's user ID.
- `createdAt` (DateTime): Creation timestamp.
- `isBookmarked` (bool): Computed context state indicating if the current active user has bookmarked this post.

## Data Transfer Objects (Data Models)

### `BookmarkModel`
Data layer representation of the Bookmark entity, handles Supabase serialization.
- Inherits from `Bookmark` entity.
- Methods:
  - `factory BookmarkModel.fromJson(Map<String, dynamic> json)`
  - `Map<String, dynamic> toJson()`
  - `Bookmark toEntity()`

### `PostModel` (Extended)
Data layer representation of the Post entity.
- Extended to map `is_bookmarked` from a left join query on the bookmarks table or fetch it separately.

## State Transitions
- **Add Bookmark**: When user taps unbookmarked post -> insert to `bookmarks` table -> update `isBookmarked` = true in UI (Optimistic).
- **Remove Bookmark**: When user taps bookmarked post -> delete from `bookmarks` table -> update `isBookmarked` = false in UI (Optimistic).

## Validation Rules
- User must be authenticated to create or remove a bookmark.
- A user cannot bookmark the same post multiple times (unique constraint on `user_id` and `post_id`).
