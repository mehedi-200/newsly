import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/data/models/storiesResponse.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/data/repositories/storyRepository.dart';

abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesFetchInProgress extends StoriesState {}

class StoriesFetchSuccess extends StoriesState {
  final List<Story> stories;
  final int currentPage;
  final bool hasMore;
  final bool fetchMoreInProgress;
  final bool fetchMoreFailed;

  StoriesFetchSuccess({
    required this.stories,
    required this.currentPage,
    required this.hasMore,
    this.fetchMoreInProgress = false,
    this.fetchMoreFailed = false,
  });

  StoriesFetchSuccess copyWith({
    List<Story>? stories,
    int? currentPage,
    bool? hasMore,
    bool? fetchMoreInProgress,
    bool? fetchMoreFailed,
  }) {
    return StoriesFetchSuccess(
      stories: stories ?? this.stories,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      fetchMoreInProgress: fetchMoreInProgress ?? this.fetchMoreInProgress,
      fetchMoreFailed: fetchMoreFailed ?? this.fetchMoreFailed,
    );
  }
}

class StoriesFetchFailure extends StoriesState {
  final String errorMessage;

  StoriesFetchFailure(this.errorMessage);
}

/// Owns one feed (one home tab). The tab creates its own instance, so the four
/// feeds page independently and keep their scroll position.
class StoriesCubit extends Cubit<StoriesState> {
  final StoryRepository _storyRepository;
  final StoryFeed feed;

  StoriesCubit({
    required this.feed,
    StoryRepository? storyRepository,
  })  : _storyRepository = storyRepository ?? StoryRepository(),
        super(StoriesInitial());

  Future<void> getStories() async {
    emit(StoriesFetchInProgress());
    try {
      final StoriesResponse response =
          await _storyRepository.getStories(feed: feed, page: 0);

      emit(StoriesFetchSuccess(
        stories: response.stories,
        currentPage: response.currentPage,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(StoriesFetchFailure(e.toString()));
    }
  }

  Future<void> getMoreStories() async {
    if (state is! StoriesFetchSuccess) return;

    final current = state as StoriesFetchSuccess;
    if (current.fetchMoreInProgress || !current.hasMore) return;

    emit(current.copyWith(fetchMoreInProgress: true, fetchMoreFailed: false));

    try {
      final StoriesResponse response = await _storyRepository.getStories(
        feed: feed,
        page: current.currentPage + 1,
      );

      emit(current.copyWith(
        stories: [...current.stories, ...response.stories],
        currentPage: response.currentPage,
        hasMore: response.hasMore,
        fetchMoreInProgress: false,
      ));
    } catch (e) {
      emit(current.copyWith(
        fetchMoreInProgress: false,
        fetchMoreFailed: true,
      ));
    }
  }

  bool get hasMore =>
      state is StoriesFetchSuccess && (state as StoriesFetchSuccess).hasMore;
}
