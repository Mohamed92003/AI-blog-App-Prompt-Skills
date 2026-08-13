import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bookmark_bloc.dart';
import '../bloc/bookmark_event.dart';
import '../bloc/bookmark_state.dart';

class BookmarkActionButton extends StatelessWidget {
  final String postId;
  final bool initialIsBookmarked;
  final bool isGuest;

  const BookmarkActionButton({
    super.key,
    required this.postId,
    required this.initialIsBookmarked,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkBloc, BookmarkState>(
      // Only listen to state changes for THIS specific post
      listenWhen: (previous, current) {
        if (current is BookmarkToggleError && current.postId == postId) return true;
        return false;
      },
      listener: (context, state) {
        if (state is BookmarkToggleError && state.postId == postId) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  context.read<BookmarkBloc>().add(
                    ToggleBookmarkEvent(
                      postId: postId,
                      isCurrentlySaved: state.revertToSaved,
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) {
        if (current is BookmarkToggling && current.postId == postId) return true;
        if (current is BookmarkToggleSuccess && current.postId == postId) return true;
        if (current is BookmarkToggleError && current.postId == postId) return true;
        return false;
      },
      builder: (context, state) {
        // Determine the current visual state
        bool isCurrentlyBookmarked = initialIsBookmarked;

        if (state is BookmarkToggling && state.postId == postId) {
          // Optimistic UI: flip the state immediately
          isCurrentlyBookmarked = !initialIsBookmarked;
        } else if (state is BookmarkToggleSuccess && state.postId == postId) {
          isCurrentlyBookmarked = state.isSaved;
        } else if (state is BookmarkToggleError && state.postId == postId) {
          // Revert to original state on error
          isCurrentlyBookmarked = state.revertToSaved;
        }

        return IconButton(
          icon: Icon(
            isCurrentlyBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isCurrentlyBookmarked ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: () async {
            if (isGuest) {
              // Trigger Guest Login Prompt Dialog
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign in Required'),
                  content: const Text('You need to be logged in to save bookmarks.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              );
              
              if (result == true) {
                // Navigate to login
              }
              return;
            }

            context.read<BookmarkBloc>().add(
              ToggleBookmarkEvent(
                postId: postId,
                isCurrentlySaved: isCurrentlyBookmarked,
              ),
            );
          },
          tooltip: isCurrentlyBookmarked ? 'Remove bookmark' : 'Bookmark post',
        );
      },
    );
  }
}
