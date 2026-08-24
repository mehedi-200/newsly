import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/data/models/storiesResponse.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/data/repositories/storyRepository.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchInProgress extends SearchState {}

class SearchSuccess extends SearchState {
  final String query;
  final List<Story> stories;
  final int currentPage;
  final bool hasMore;
  final bool fetchMoreInProgress;

  SearchSuccess({
    required this.query,
    required this.stories,
    required this.currentPage,
    required this.hasMore,
    this.fetchMoreInProgress = false,
  });

  SearchSuccess copyWith({
    String? query,
    List<Story>? stories,
    int? currentPage,
    bool? hasMore,
    bool? fetchMoreInProgress,
  }) {
    return SearchSuccess(
      query: query ?? this.query,
      stories: stories ?? this.stories,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      fetchMoreInProgress: fetchMoreInProgress ?? this.fetchMoreInProgress,
    );
  }
}

class SearchFailure extends SearchState {
  final String errorMessage;

  SearchFailure(this.errorMessage);
}

class SearchCubit extends Cubit<SearchState> {
  final StoryRepository _storyRepository;

  SearchCubit({StoryRepository? storyRepository})
      : _storyRepository = storyRepository ?? StoryRepository(),
        super(SearchInitial());

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchInProgress());

    try {
      final StoriesResponse response =
          await _storyRepository.searchStories(query: trimmed, page: 0);

      //A newer query may have completed while this one was in flight.
      if (isClosed) return;

      emit(SearchSuccess(
        query: trimmed,
        stories: response.stories,
        currentPage: response.currentPage,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(SearchFailure(e.toString()));
    }
  }

  Future<void> searchMore() async {
    if (state is! SearchSuccess) return;

    final current = state as SearchSuccess;
    if (current.fetchMoreInProgress || !current.hasMore) return;

    emit(current.copyWith(fetchMoreInProgress: true));

    try {
      final StoriesResponse response = await _storyRepository.searchStories(
        query: current.query,
        page: current.currentPage + 1,
      );

      emit(current.copyWith(
        stories: [...current.stories, ...response.stories],
        currentPage: response.currentPage,
        hasMore: response.hasMore,
        fetchMoreInProgress: false,
      ));
    } catch (e) {
      emit(current.copyWith(fetchMoreInProgress: false));
    }
  }

  void clear() => emit(SearchInitial());
}
