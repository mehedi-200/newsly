import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/cubits/stories/searchCubit.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:newsly/ui/widgets/emptyContainer.dart';
import 'package:newsly/ui/widgets/errorContainer.dart';
import 'package:newsly/ui/widgets/storiesShimmer.dart';
import 'package:newsly/ui/widgets/storyTile.dart';
import 'package:newsly/utils/labelKeys.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static Widget getRouteInstance() {
    return BlocProvider<SearchCubit>(
      create: (_) => SearchCubit(),
      child: const SearchScreen(),
    );
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<SearchCubit>().searchMore();
    }
  }

  /// One request per pause in typing rather than one per keystroke.
  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchCubit>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onQueryChanged,
          onSubmitted: (query) => context.read<SearchCubit>().search(query),
          decoration: InputDecoration(
            hintText: "Search Hacker News",
            border: InputBorder.none,
            hintStyle: TextStyle(color: customColors.subtitleColor),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              _controller.clear();
              context.read<SearchCubit>().clear();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const EmptyContainer(
              message: "Search stories by keyword, author or domain",
              icon: Icons.search_rounded,
            );
          }

          if (state is SearchInProgress) {
            return const StoriesShimmer(itemCount: 6);
          }

          if (state is SearchFailure) {
            return ErrorContainer(
              errorMessage: state.errorMessage,
              onRetry: () =>
                  context.read<SearchCubit>().search(_controller.text),
            );
          }

          final success = state as SearchSuccess;

          if (success.stories.isEmpty) {
            return const EmptyContainer(message: noStoriesFoundKey);
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: success.stories.length + (success.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= success.stories.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                  ),
                );
              }
              return StoryTile(story: success.stories[index]);
            },
          );
        },
      ),
    );
  }
}
