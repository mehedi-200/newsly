import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/cubits/bookmarks/bookmarksCubit.dart';
import 'package:newsly/ui/widgets/emptyContainer.dart';
import 'package:newsly/ui/widgets/storyTile.dart';
import 'package:newsly/utils/labelKeys.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  static Widget getRouteInstance() => const BookmarksScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        actions: [
          BlocBuilder<BookmarksCubit, BookmarksState>(
            builder: (context, state) {
              if (state.stories.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: "Clear all",
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => _confirmClear(context),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          if (state.stories.isEmpty) {
            return const EmptyContainer(
              message: noBookmarksFoundKey,
              icon: Icons.bookmark_border_rounded,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: state.stories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                StoryTile(story: state.stories[index]),
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Clear bookmarks?"),
        content: const Text("This removes every saved story."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<BookmarksCubit>().clearAll();
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}
