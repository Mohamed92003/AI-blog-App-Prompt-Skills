# Research: Post Bookmarks

## Technical Context Unknowns

### Framework & Language
- **Decision**: Flutter 3.24+, Dart 3.5+
- **Rationale**: Core requirement for the project.
- **Alternatives considered**: N/A

### State Management
- **Decision**: flutter_bloc (Bloc pattern)
- **Rationale**: Mandated by project constitution for state management. Separated event and state classes.
- **Alternatives considered**: Riverpod, Provider (rejected due to constitution).

### Backend & Database
- **Decision**: supabase_flutter
- **Rationale**: Mandated backend for the project.
- **Alternatives considered**: Firebase, custom backend (rejected).

### Offline Strategy
- **Decision**: Online-first (Supabase queries) with offline error notice.
- **Rationale**: Clarification Q1 answer. Avoids complex local caching.
- **Alternatives considered**: Local caching with SQLite/Hive (rejected per spec).

### Pagination Strategy
- **Decision**: Infinite scrolling pagination (20 posts per batch) with pull-to-refresh.
- **Rationale**: Clarification Q5 answer.
- **Alternatives considered**: Single fetch, Load More button (rejected per spec).

### Deleted Post Handling
- **Decision**: Display a disabled placeholder card.
- **Rationale**: Clarification Q4 answer.
- **Alternatives considered**: Auto-exclude, cascade delete (rejected per spec).
