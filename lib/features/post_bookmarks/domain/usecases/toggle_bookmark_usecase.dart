import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/bookmark_repository.dart';

class ToggleBookmarkUseCase {
  final BookmarkRepository repository;

  ToggleBookmarkUseCase(this.repository);

  Future<Either<Failure, dynamic>> call({required ToggleBookmarkParams params}) async {
    if (params.save) {
      return await repository.addBookmark(params.postId);
    } else {
      return await repository.removeBookmark(params.postId);
    }
  }
}

class ToggleBookmarkParams extends Equatable {
  final String postId;
  final bool save;

  const ToggleBookmarkParams({required this.postId, required this.save});

  @override
  List<Object> get props => [postId, save];
}
