import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/app/routes.dart';
import 'package:newsly/cubits/bookmarks/bookmarksCubit.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:newsly/utils/utils.dart';
import 'package:get/get.dart';

class StoryTile extends StatelessWidget {
  final Story story;

  const StoryTile({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final domain = Utils.domainOf(story.url);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(Routes.storyDetailsScreen, arguments: story),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 6, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      story.title ?? "",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                  _BookmarkButton(story: story),
                ],
              ),
              if (domain.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  domain,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.arrow_upward_rounded,
                      size: 14, color: customColors.upvoteColor),
                  const SizedBox(width: 3),
                  Text("${story.points}",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: customColors.subtitleColor)),
                  const SizedBox(width: 14),
                  Icon(Icons.mode_comment_outlined,
                      size: 13, color: customColors.subtitleColor),
                  const SizedBox(width: 4),
                  Text("${story.commentsCount}",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: customColors.subtitleColor)),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      Utils.timeAgo(story.createdAt),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: customColors.subtitleColor),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final Story story;

  const _BookmarkButton({required this.story});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksCubit, BookmarksState>(
      builder: (context, state) {
        final isBookmarked = context.read<BookmarksCubit>().isBookmarked(
              story.id,
            );

        return IconButton(
          visualDensity: VisualDensity.compact,
          iconSize: 20,
          icon: Icon(
            isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: isBookmarked
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).extension<CustomColors>()!.subtitleColor,
          ),
          onPressed: () async {
            final saved =
                await context.read<BookmarksCubit>().toggleBookmark(story);
            if (!context.mounted) return;
            Utils.showSnackBar(
              context,
              saved ? "Saved to bookmarks" : "Removed from bookmarks",
            );
          },
        );
      },
    );
  }
}
