import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/cubits/stories/storiesCubit.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/ui/widgets/errorContainer.dart';
import 'package:newsly/ui/widgets/emptyContainer.dart';
import 'package:newsly/ui/widgets/storiesShimmer.dart';
import 'package:newsly/ui/widgets/storyTile.dart';
import 'package:newsly/utils/labelKeys.dart';

/// One home tab. Owns its [StoriesCubit] so each feed pages independently and
/// keeps its list state while the user moves between tabs.
class StoriesTabView extends StatelessWidget {
  final StoryFeed feed;

  const StoriesTabView({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoriesCubit>(
      create: (_) => StoriesCubit(feed: feed)..getStories(),
      child: _StoriesTabViewBody(feed: feed),
    );
  }
}

class _StoriesTabViewBody extends StatefulWidget {
  final StoryFeed feed;

  const _StoriesTabViewBody({required this.feed});

  @override
  State<_StoriesTabViewBody> createState() => _StoriesTabViewBodyState();
}

class _StoriesTabViewBodyState extends State<_StoriesTabViewBody>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    //Start the next page one screen before the bottom so the list rarely
    //shows the loader.
    if (position.pixels >=
        position.maxScrollExtent - position.viewportDimension) {
      context.read<StoriesCubit>().getMoreStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<StoriesCubit, StoriesState>(
      builder: (context, state) {
        if (state is StoriesFetchInProgress || state is StoriesInitial) {
          return const StoriesShimmer();
        }

        if (state is StoriesFetchFailure) {
          return ErrorContainer(
            errorMessage: state.errorMessage,
            onRetry: () => context.read<StoriesCubit>().getStories(),
          );
        }

        final success = state as StoriesFetchSuccess;

        if (success.stories.isEmpty) {
          return const EmptyContainer(message: noStoriesFoundKey);
        }

        return RefreshIndicator(
          onRefresh: () => context.read<StoriesCubit>().getStories(),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: success.stories.length + (success.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= success.stories.length) {
                return _PaginationFooter(
                  failed: success.fetchMoreFailed,
                  onRetry: () => context.read<StoriesCubit>().getMoreStories(),
                );
              }

              return StoryTile(story: success.stories[index]);
            },
          ),
        );
      },
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  final bool failed;
  final VoidCallback onRetry;

  const _PaginationFooter({required this.failed, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: failed
            ? TextButton(onPressed: onRetry, child: const Text("Retry"))
            : const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
      ),
    );
  }
}
