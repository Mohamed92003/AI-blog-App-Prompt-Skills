import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bookmark_list_bloc.dart';
import '../bloc/bookmark_list_event.dart';
import '../bloc/bookmark_list_state.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BookmarkListBloc>().add(const FetchBookmarksEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<BookmarkListBloc>().add(LoadMoreBookmarksEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  Future<void> _onRefresh() async {
    context.read<BookmarkListBloc>().add(const FetchBookmarksEvent(isRefresh: true));
    // Provide a small delay so refresh indicator has time to show animation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<BookmarkListBloc, BookmarkListState>(
        builder: (context, state) {
          if (state is BookmarkListInitial) {
            return const SizedBox.shrink();
          }
          if (state is BookmarkListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookmarkListError) {
            return Center(child: Text(state.message));
          }
          if (state is BookmarkListLoaded) {
            if (state.bookmarks.isEmpty) {
              return _buildEmptyState(context);
            }
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.bookmarks.length
                    : state.bookmarks.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.bookmarks.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final bookmark = state.bookmarks[index];
                  // Assume a PostListTile or similar exists. For now, simple ListTile.
                  return ListTile(
                    title: Text('Post ID: ${bookmark.postId}'),
                    subtitle: Text('Bookmarked on ${bookmark.createdAt.toString()}'),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No bookmarked posts yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Save interesting articles to read later.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to feed
            },
            child: const Text('Go to Feed'),
          ),
        ],
      ),
    );
  }
}
