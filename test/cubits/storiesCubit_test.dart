import 'package:flutter_test/flutter_test.dart';
import 'package:newsly/cubits/stories/storiesCubit.dart';
import 'package:newsly/data/models/comment.dart';
import 'package:newsly/data/models/storiesResponse.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/data/repositories/storyRepository.dart';
import 'package:newsly/utils/api.dart';

/// Stands in for the network. Records the pages it was asked for so the test
/// can assert the cubit paginates rather than refetching page 0.
class _FakeStoryRepository extends StoryRepository {
  _FakeStoryRepository({this.totalPages = 3, this.shouldFail = false});

  final int totalPages;
  final bool shouldFail;
  final List<int> requestedPages = [];

  @override
  Future<StoriesResponse> getStories({
    required StoryFeed feed,
    required int page,
  }) async {
    requestedPages.add(page);

    if (shouldFail) throw ApiException('network down');

    return StoriesResponse(
      stories: [
        Story(id: 'p$page-a', title: 'Story A on page $page'),
        Story(id: 'p$page-b', title: 'Story B on page $page'),
      ],
      currentPage: page,
      totalPages: totalPages,
    );
  }

  @override
  Future<List<Comment>> getComments({required String storyId}) async => [];
}

void main() {
  group('StoriesCubit', () {
    test('emits success with the first page', () async {
      final repository = _FakeStoryRepository();
      final cubit =
          StoriesCubit(feed: StoryFeed.top, storyRepository: repository);

      await cubit.getStories();

      expect(cubit.state, isA<StoriesFetchSuccess>());
      final state = cubit.state as StoriesFetchSuccess;
      expect(state.stories.length, 2);
      expect(state.currentPage, 0);
      expect(state.hasMore, isTrue);
      expect(repository.requestedPages, [0]);
    });

    test('appends the next page instead of replacing the list', () async {
      final repository = _FakeStoryRepository();
      final cubit =
          StoriesCubit(feed: StoryFeed.top, storyRepository: repository);

      await cubit.getStories();
      await cubit.getMoreStories();

      final state = cubit.state as StoriesFetchSuccess;
      expect(state.stories.length, 4);
      expect(state.stories.first.id, 'p0-a');
      expect(state.stories.last.id, 'p1-b');
      expect(repository.requestedPages, [0, 1]);
    });

    test('stops paginating once the last page is reached', () async {
      final repository = _FakeStoryRepository(totalPages: 1);
      final cubit =
          StoriesCubit(feed: StoryFeed.top, storyRepository: repository);

      await cubit.getStories();
      expect(cubit.hasMore, isFalse);

      await cubit.getMoreStories();
      expect(repository.requestedPages, [0]);
    });

    test('emits failure when the first page throws', () async {
      final repository = _FakeStoryRepository(shouldFail: true);
      final cubit =
          StoriesCubit(feed: StoryFeed.top, storyRepository: repository);

      await cubit.getStories();

      expect(cubit.state, isA<StoriesFetchFailure>());
    });

    test('a failed page-2 fetch keeps the stories already on screen', () async {
      final cubit = StoriesCubit(
        feed: StoryFeed.top,
        storyRepository: _FailAfterFirstPageRepository(),
      );

      await cubit.getStories();
      await cubit.getMoreStories();

      expect(cubit.state, isA<StoriesFetchSuccess>());
      final state = cubit.state as StoriesFetchSuccess;
      expect(state.stories.length, 2);
      expect(state.fetchMoreFailed, isTrue);
      expect(state.fetchMoreInProgress, isFalse);
    });
  });
}

class _FailAfterFirstPageRepository extends _FakeStoryRepository {
  @override
  Future<StoriesResponse> getStories({
    required StoryFeed feed,
    required int page,
  }) async {
    if (page > 0) throw ApiException('network down');
    return super.getStories(feed: feed, page: page);
  }
}
