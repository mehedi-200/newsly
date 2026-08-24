import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:newsly/app/routes.dart';
import 'package:newsly/cubits/settings/themeCubit.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/ui/screens/home/widgets/storiesTabView.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Widget getRouteInstance() => const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return DefaultTabController(
      length: StoryFeed.values.length,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title: Row(
            children: [
              Icon(Icons.bolt_rounded,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                "Newsly",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "Search",
              icon: const Icon(Icons.search_rounded),
              onPressed: () => Get.toNamed(Routes.searchScreen),
            ),
            IconButton(
              tooltip: "Bookmarks",
              icon: const Icon(Icons.bookmarks_outlined),
              onPressed: () => Get.toNamed(Routes.bookmarksScreen),
            ),
            const _ThemeToggleButton(),
            const SizedBox(width: 4),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: customColors.subtitleColor,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: customColors.dividerColor,
            tabs:
                StoryFeed.values.map((feed) => Tab(text: feed.label)).toList(),
          ),
        ),
        body: TabBarView(
          children: StoryFeed.values
              .map((feed) => StoriesTabView(feed: feed))
              .toList(),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final icon = switch (themeMode) {
          ThemeMode.system => Icons.brightness_auto_rounded,
          ThemeMode.light => Icons.light_mode_rounded,
          ThemeMode.dark => Icons.dark_mode_rounded,
        };

        return IconButton(
          tooltip: "Theme: ${themeMode.name}",
          icon: Icon(icon),
          onPressed: () => context.read<ThemeCubit>().toggleThemeMode(),
        );
      },
    );
  }
}
