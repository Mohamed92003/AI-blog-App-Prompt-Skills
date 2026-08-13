---
description: "Task list template for feature implementation"
---

# Tasks: Post Bookmarks

**Input**: Design documents from `/specs/002-post-bookmarks/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md

**Tests**: The examples below include test tasks based on project testing mandates.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create project structure for the new feature in `lib/features/post_bookmarks/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 [P] Create Bookmark entity in `lib/features/post_bookmarks/domain/entities/bookmark.dart`
- [x] T003 [P] Create BookmarkRepository interface in `lib/features/post_bookmarks/domain/repositories/bookmark_repository.dart`
- [x] T004 [P] Create BookmarkModel in `lib/features/post_bookmarks/data/models/bookmark_model.dart`
- [x] T005 [P] Create BookmarkRemoteDataSource in `lib/features/post_bookmarks/data/datasources/bookmark_remote_data_source.dart`
- [x] T006 [P] Create BookmarkLocalDataSource in `lib/features/post_bookmarks/data/datasources/bookmark_local_data_source.dart`
- [x] T007 Create BookmarkRepositoryImpl in `lib/features/post_bookmarks/data/repositories/bookmark_repository_impl.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Bookmark and Remove Bookmark from Posts (Priority: P1) 🎯 MVP

**Goal**: Allow users to save a post for later by clicking a bookmark action and remove it at any time.

**Independent Test**: Log in as a user, navigate to a post, tap the bookmark action, verify visual indicator changes to saved state. Tap action again, verify visual indicator reverts.

### Tests for User Story 1 ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T008 [P] [US1] Create unit tests for ToggleBookmarkUseCase in `test/features/post_bookmarks/domain/usecases/toggle_bookmark_usecase_test.dart`
- [x] T009 [P] [US1] Create bloc tests for toggle action in `test/features/post_bookmarks/presentation/bloc/bookmark_bloc_test.dart`

### Implementation for User Story 1

- [x] T010 [P] [US1] Create ToggleBookmarkUseCase in `lib/features/post_bookmarks/domain/usecases/toggle_bookmark_usecase.dart`
- [x] T011 [US1] Create BookmarkEvent and BookmarkState in `lib/features/post_bookmarks/presentation/bloc/bookmark_event.dart` and `bookmark_state.dart`
- [x] T012 [US1] Implement BookmarkBloc with optimistic toggle logic (including debouncing for rapid taps) in `lib/features/post_bookmarks/presentation/bloc/bookmark_bloc.dart`
- [x] T013 [US1] Create BookmarkActionButton widget in `lib/features/post_bookmarks/presentation/widgets/bookmark_action_button.dart`
- [x] T014 [US1] Update Post entity and PostModel to include isBookmarked flag in `lib/features/posts/domain/entities/post.dart`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Dedicated Bookmarks Screen (Priority: P1)

**Goal**: Open a dedicated Bookmarks screen that lists all saved blog posts ordered by most recently bookmarked.

**Independent Test**: Save 3 blog posts, navigate to the Bookmarks screen, verify all 3 posts are listed with correct title, author, and preview information.

### Tests for User Story 2 ⚠️

- [x] T015 [P] [US2] Create unit tests for GetBookmarkedPostsUseCase in `test/features/post_bookmarks/domain/usecases/get_bookmarked_posts_usecase_test.dart`
- [x] T016 [P] [US2] Create bloc tests for fetching list in `test/features/post_bookmarks/presentation/bloc/bookmark_list_bloc_test.dart`

### Implementation for User Story 2

- [x] T017 [P] [US2] Create GetBookmarkedPostsUseCase in `lib/features/post_bookmarks/domain/usecases/get_bookmarked_posts_usecase.dart`
- [x] T018 [US2] Create BookmarkListBloc in `lib/features/post_bookmarks/presentation/bloc/bookmark_list_bloc.dart`
- [x] T019 [US2] Create BookmarksScreen UI in `lib/features/post_bookmarks/presentation/screens/bookmarks_screen.dart`
- [x] T020 [US2] Add empty state illustration handling in `lib/features/post_bookmarks/presentation/screens/bookmarks_screen.dart`
- [x] T021 [US2] Integrate BookmarksScreen into main bottom navigation bar in `lib/core/presentation/screens/main_navigation_screen.dart`
- [x] T021a [US2] Implement infinite scrolling pagination logic (20 items/page) in `lib/features/post_bookmarks/presentation/bloc/bookmark_list_bloc.dart`
- [x] T021b [US2] Implement pull-to-refresh handler in `lib/features/post_bookmarks/presentation/screens/bookmarks_screen.dart`

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Access Control for Guest Users (Priority: P2)

**Goal**: Prompt unauthenticated guest users to log in or register when attempting to bookmark.

**Independent Test**: Navigate to a post as a guest user, tap the bookmark button, verify a login prompt/dialog appears directing the user to sign in.

### Tests for User Story 3 ⚠️

- [x] T022 [P] [US3] Create unit tests for auth guard logic in `test/features/post_bookmarks/presentation/bloc/bookmark_bloc_auth_test.dart`

### Implementation for User Story 3

- [x] T023 [US3] Add guest check logic in BookmarkBloc before triggering toggle usecase in `lib/features/post_bookmarks/presentation/bloc/bookmark_bloc.dart`
- [x] T024 [US3] Implement GuestLoginPromptDialog widget in `lib/features/post_bookmarks/presentation/widgets/guest_login_prompt_dialog.dart`
- [x] T025 [US3] Trigger GuestLoginPromptDialog from UI when guest attempts to bookmark in `lib/features/post_bookmarks/presentation/widgets/bookmark_action_button.dart`

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T026 Add error rollback notification Snackbar handling (including a retry action) in `lib/features/post_bookmarks/presentation/screens/bookmarks_screen.dart`
- [x] T027 Register all dependencies in `lib/core/di/injection_container.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - Independently testable
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - Independently testable

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "T008 [P] [US1] Create unit tests for ToggleBookmarkUseCase in test/features/post_bookmarks/domain/usecases/toggle_bookmark_usecase_test.dart"
Task: "T009 [P] [US1] Create bloc tests for toggle action in test/features/post_bookmarks/presentation/bloc/bookmark_bloc_test.dart"

# Launch all implementations for User Story 1 together once tests exist:
Task: "T010 [P] [US1] Create ToggleBookmarkUseCase in lib/features/post_bookmarks/domain/usecases/toggle_bookmark_usecase.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently
