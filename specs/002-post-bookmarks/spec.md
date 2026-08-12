# Feature Specification: Post Bookmarks

**Feature Branch**: `002-post-bookmarks`  
**Created**: 2026-08-12  
**Status**: Draft  
**Input**: User description: "add bookmarks to blog posts. a logged-in user can save any post for later ,remove it any time ,and open a dedicated bookmarks screen that list all saved posts."

## Clarifications

### Session 2026-08-13

- Q: How should the Bookmarks feature handle data fetching and offline persistence? → A: Online-first via Supabase queries with informative error notification and retry state when offline.
- Q: How should the UI handle bookmark toggle interactions and network failure rollbacks? → A: Optimistic UI toggle immediately with automatic rollback and error notification on failure.
- Q: Where should the entry point for accessing the dedicated Bookmarks screen be located? → A: Dedicated tab in the main bottom navigation bar.
- Q: How should the Bookmarks screen handle a bookmarked post if the author deletes the underlying post? → A: Display a disabled placeholder card ("This post was deleted by its author") with a button to remove bookmark.
- Q: How should the Bookmarks screen handle loading and pagination when a user has a large number of saved posts? → A: Infinite scrolling pagination (20 posts per page with pull-to-refresh support).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Bookmark and Remove Bookmark from Posts (Priority: P1)

As a logged-in user viewing blog posts (on feed or post detail view), I want to save a post for later by clicking a bookmark action and remove it at any time, so that I can manage my saved articles quickly.

**Why this priority**: Core value of the feature; enables saving and removing post references.

**Independent Test**: Log in as a user, navigate to a post, tap the bookmark action, verify visual indicator changes to saved state. Tap action again, verify visual indicator reverts to unsaved state.

**Acceptance Scenarios**:

1. **Given** a logged-in user viewing a post that is not currently saved, **When** the user taps the bookmark action, **Then** the post is added to user's saved list and the bookmark indicator visually changes to filled/saved.
2. **Given** a logged-in user viewing a saved post, **When** the user taps the bookmark action, **Then** the post is removed from the user's saved list and the indicator visually reverts to outline/unsaved.
3. **Given** a network failure during bookmarking, **When** the user attempts to toggle bookmark status, **Then** an informative error notification is displayed and the bookmark state reverts to its previous state.

---

### User Story 2 - Dedicated Bookmarks Screen (Priority: P1)

As a logged-in user, I want to open a dedicated Bookmarks screen that lists all my saved blog posts ordered by most recently bookmarked, so that I can easily find and read them.

**Why this priority**: Essential companion to saving posts; provides central destination to view saved content.

**Independent Test**: Save 3 blog posts, navigate to the Bookmarks screen, verify all 3 posts are listed with correct title, author, and preview information.

**Acceptance Scenarios**:

1. **Given** a logged-in user with saved posts, **When** navigating to the Bookmarks screen, **Then** all saved posts are loaded and displayed in chronological order (most recently saved first).
2. **Given** a logged-in user with no saved posts, **When** navigating to the Bookmarks screen, **Then** a friendly empty-state illustration and prompt ("No bookmarked posts yet") are displayed.
3. **Given** a logged-in user on the Bookmarks screen, **When** the user removes a post from the list, **Then** the post is immediately removed from the list view without requiring a manual refresh.
4. **Given** a logged-in user on the Bookmarks screen, **When** selecting a bookmarked post, **Then** the user is navigated to the full post reading view.

---

### User Story 3 - Access Control for Guest Users (Priority: P2)

As an unauthenticated (guest) user attempting to bookmark a post, I want to be prompted to log in or register, so that I understand bookmarking requires an account.

**Why this priority**: Prevents unauthenticated errors and guides guest users to sign up or sign in.

**Independent Test**: Navigate to a post as a guest user, tap the bookmark button, verify a login prompt/dialog appears directing the user to sign in.

**Acceptance Scenarios**:

1. **Given** an unauthenticated guest user viewing a blog post, **When** tapping the bookmark button, **Then** a login prompt modal or banner appears explaining that bookmarking requires an account.
2. **Given** a guest user who signs in after seeing the prompt, **When** authentication completes, **Then** the user is returned to the post with bookmark functionality enabled.

---

### Edge Cases

- What happens if a post is deleted by its author while a user has it bookmarked? The Bookmarks screen displays a disabled placeholder card stating "This post was deleted by its author" with an inline action button allowing the user to remove the bookmark.
- How does the system handle rapid double-tapping on the bookmark button? Debounces or disables action input while the asynchronous operation completes to prevent duplicate network calls.
- What happens when a user logs out? Local bookmark session state is cleared so the next user sees only their own saved posts upon logging in.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow logged-in users to toggle bookmark status (save / remove) on any blog post from the post feed and post detail views.
- **FR-002**: System MUST persist user bookmarks per user account so saved posts are synced across user sessions and devices.
- **FR-003**: System MUST provide a dedicated Bookmarks screen listing all posts saved by the currently authenticated user.
- **FR-004**: System MUST display saved posts in reverse chronological order (most recently bookmarked first).
- **FR-005**: System MUST display a clear empty state message when the user has no bookmarked posts.
- **FR-006**: System MUST prompt unauthenticated users to log in or sign up when attempting to use the bookmark feature.
- **FR-007**: System MUST provide real-time or immediate UI updates when bookmark status changes without full page reload.
- **FR-008**: System MUST operate using an online-first architecture (direct Supabase queries) and display an informative error state with a retry option when network connectivity is unavailable.
- **FR-009**: System MUST perform optimistic UI updates upon bookmark toggle actions, instantly updating visual state and performing automatic state rollback with an error notification if the server sync fails.
- **FR-010**: System MUST expose the dedicated Bookmarks screen via a dedicated tab in the main bottom navigation bar.
- **FR-011**: System MUST display a disabled placeholder card ("This post was deleted by its author") with an option to remove the bookmark when a bookmarked post has been deleted by its author.
- **FR-012**: System MUST load saved posts in the Bookmarks screen using infinite scrolling pagination (20 posts per page) and support pull-to-refresh.

### Key Entities

- **Bookmark**: Represents a link between a User and a Post. Key attributes: `id`, `user_id`, `post_id`, `created_at`.
- **Post**: Represents a blog post entity. Key attributes: `id`, `title`, `content`, `author_id`, `created_at`, `is_bookmarked` (computed context state for active user).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can toggle a post's bookmark status with visual feedback in under 300 milliseconds.
- **SC-002**: 100% of bookmarked posts accurately appear in the user's Bookmarks screen upon navigation.
- **SC-003**: Users can navigate to and view their saved posts list in under 1 second on a standard network connection.
- **SC-004**: Zero unhandled exceptions or crashes when offline or when network connectivity is lost during a bookmark operation.

## Assumptions

- Users must be authenticated to persist bookmarks on the server.
- Existing blog post models and post detail screens will be extended with bookmark action controls.
- Dedicated Bookmarks screen will be accessible via standard app navigation (e.g., bottom navigation bar or drawer menu).
