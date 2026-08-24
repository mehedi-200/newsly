import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:newsly/cubits/bookmarks/bookmarksCubit.dart';
import 'package:newsly/cubits/stories/commentsCubit.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/ui/screens/storyDetails/widgets/commentTile.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:newsly/ui/widgets/emptyContainer.dart';
import 'package:newsly/ui/widgets/errorContainer.dart';
import 'package:newsly/utils/labelKeys.dart';
import 'package:newsly/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class StoryDetailsScreen extends StatelessWidget {
  final Story story;

  const StoryDetailsScreen({super.key, required this.story});

  static Widget getRouteInstance() {
    return BlocProvider<CommentsCubit>(
      create: (_) => CommentsCubit(),
      child: StoryDetailsScreen(story: Get.arguments as Story),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Kick the fetch off once the widget is in the tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CommentsCubit>();
      if (cubit.state is CommentsInitial) {
        cubit.getComments(storyId: story.id);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Story"),
        actions: [
          IconButton(
            tooltip: "Share",
            icon: const Icon(Icons.share_outlined),
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: "${story.title}\n\n${story.openableUrl}",
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _StoryHeader(story: story)),
              if (state is CommentsFetchInProgress)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (state is CommentsFetchFailure)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: ErrorContainer(
                      errorMessage: state.errorMessage,
                      onRetry: () => context
                          .read<CommentsCubit>()
                          .getComments(storyId: story.id),
                    ),
                  ),
                )
              else if (state is CommentsFetchSuccess)
                if (state.comments.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: EmptyContainer(
                        message: noCommentsFoundKey,
                        icon: Icons.forum_outlined,
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) =>
                        CommentTile(comment: state.comments[index]),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  final Story story;

  const _StoryHeader({required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final domain = Utils.domainOf(story.url);
    final selfText = Utils.stripHtml(story.text);

    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.title ?? "",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "by ${story.author ?? "unknown"} · ${Utils.timeAgo(story.createdAt)}",
            style: theme.textTheme.bodySmall
                ?.copyWith(color: customColors.subtitleColor),
          ),
          if (selfText.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(selfText,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(
                icon: Icons.arrow_upward_rounded,
                label: "${story.points}",
                color: customColors.upvoteColor!,
              ),
              const SizedBox(width: 18),
              _Stat(
                icon: Icons.mode_comment_outlined,
                label: "${story.commentsCount}",
                color: customColors.subtitleColor!,
              ),
              const Spacer(),
              BlocBuilder<BookmarksCubit, BookmarksState>(
                builder: (context, state) {
                  final isBookmarked =
                      context.read<BookmarksCubit>().isBookmarked(story.id);
                  return IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isBookmarked
                          ? theme.colorScheme.primary
                          : customColors.subtitleColor,
                    ),
                    onPressed: () async {
                      final saved = await context
                          .read<BookmarksCubit>()
                          .toggleBookmark(story);
                      if (!context.mounted) return;
                      Utils.showSnackBar(
                        context,
                        saved ? "Saved to bookmarks" : "Removed from bookmarks",
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Utils.openUrl(story.openableUrl),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                story.isSelfPost ? "Open on Hacker News" : "Read on $domain",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Stat({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(label,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
