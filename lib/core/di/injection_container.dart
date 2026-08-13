import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/bookmarks/data/datasources/bookmarks_datasource.dart';
import '../../features/bookmarks/data/datasources/bookmarks_datasource_impl.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repository_impl.dart';
import '../../features/bookmarks/domain/repositories/bookmarks_repository.dart';
import '../../features/bookmarks/domain/usecases/toggle_bookmark.dart';
import '../../features/bookmarks/domain/usecases/is_bookmarked.dart';
import '../../features/bookmarks/domain/usecases/get_bookmarks.dart';
import '../../features/bookmarks/presentation/bloc/bookmark_toggle_bloc.dart';
import '../../features/bookmarks/presentation/bloc/bookmarks_bloc.dart';

// Post Bookmarks Feature Imports

final sl = GetIt.instance;

void initDependencies() {
  final supabaseClient = Supabase.instance.client;

  // Data sources
  sl.registerLazySingleton<BookmarksDataSource>(
    () => BookmarksDataSourceImpl(supabaseClient),
  );

  // Repositories
  sl.registerLazySingleton<BookmarksRepository>(
    () => BookmarksRepositoryImpl(sl<BookmarksDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => ToggleBookmark(sl<BookmarksRepository>()));
  sl.registerLazySingleton(() => IsBookmarked(sl<BookmarksRepository>()));
  sl.registerLazySingleton(() => GetBookmarks(sl<BookmarksRepository>()));

  // BLoCs
  sl.registerFactory(
    () => BookmarkToggleBloc(
      toggleBookmark: sl<ToggleBookmark>(),
      bookmarksRepository: sl<BookmarksRepository>(),
    ),
  );
  sl.registerFactory(
    () => BookmarksBloc(getBookmarks: sl<GetBookmarks>()),
  );

  // --- Post Bookmarks Feature (Clean Architecture) ---

  // Data Sources (Assuming implementations exist elsewhere or mock them)
  // sl.registerLazySingleton<BookmarkLocalDataSource>(() => BookmarkLocalDataSourceImpl());
  // sl.registerLazySingleton<BookmarkRemoteDataSource>(() => BookmarkRemoteDataSourceImpl(supabaseClient));

  // Repository
  /* 
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(
      remoteDataSource: sl<BookmarkRemoteDataSource>(),
      localDataSource: sl<BookmarkLocalDataSource>(),
    ),
  );
  */

  // Use Cases
  /*
  sl.registerLazySingleton(() => ToggleBookmarkUseCase(sl<BookmarkRepository>()));
  sl.registerLazySingleton(() => GetBookmarkedPostsUseCase(sl<BookmarkRepository>()));
  */

  // BLoCs
  /*
  sl.registerFactory(() => BookmarkBloc(toggleBookmarkUseCase: sl<ToggleBookmarkUseCase>()));
  sl.registerFactory(() => BookmarkListBloc(getBookmarkedPostsUseCase: sl<GetBookmarkedPostsUseCase>()));
  */
}
