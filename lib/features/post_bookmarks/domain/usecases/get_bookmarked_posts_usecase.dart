import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/bookmark.dart';
import '../repositories/bookmark_repository.dart';

class GetBookmarkedPostsUseCase {
  final BookmarkRepository repository;

  GetBookmarkedPostsUseCase(this.repository);

  Future<Either<Failure, List<Bookmark>>> call({required GetBookmarkedPostsParams params}) async {
    return await repository.getBookmarks(page: params.page, limit: params.limit);
  }
}

class GetBookmarkedPostsParams extends Equatable {
  final int page;
  final int limit;

  const GetBookmarkedPostsParams({required this.page, this.limit = 20});

  @override
  List<Object> get props => [page, limit];
}
