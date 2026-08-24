import 'package:flutter_test/flutter_test.dart';
import 'package:newsly/cubits/stories/commentsCubit.dart';
import 'package:newsly/data/models/comment.dart';
import 'package:newsly/data/models/storiesResponse.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/data/repositories/storyRepository.dart';

/// Holds the request open until the test releases it, so the test can close
/// the cubit while a fetch is still in flight.
class _SlowStoryRepository extends StoryRepository {
  final List<String> requestedStoryIds = [];

  @override
  Future<List<Comment>> getComments({required String storyId}) async {
    requestedStoryIds.add(storyId);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return const [Comment(id: '1', author: 'a', text: 'hi')];
  }

  @override
  Future<StoriesResponse> getStories({
    required StoryFeed feed,
    required int page,
  }) async =>
      const StoriesResponse(stories: [], currentPage: 0, totalPages: 0);
}

void main() {
  group('CommentsCubit', () {
    test('fetches once on construction', () async {
      final repository = _SlowStoryRepository();
      final cubit = CommentsCubit(storyId: '42', storyRepository: repository);

      expect(cubit.state, isA<CommentsFetchInProgress>());

      await Future<void>.delayed(const Duration(milliseconds: 40));

      expect(cubit.state, isA<CommentsFetchSuccess>());
      expect(repository.requestedStoryIds, ['42']);
    });

    test('a fetch requested after close does not throw', () async {
      final cubit = CommentsCubit(
        storyId: '42',
        storyRepository: _SlowStoryRepository(),
      );

      //The screen is popped, then a rebuild asks for the comments again. This
      //is the exact sequence that threw "Cannot emit new states after calling
      //close" on device.
      await cubit.close();

      await expectLater(cubit.getComments(), completes);
    });

    test('closing the cubit mid-fetch does not throw', () async {
      final cubit = CommentsCubit(
        storyId: '42',
        storyRepository: _SlowStoryRepository(),
      );

      final pending = cubit.getComments();
      await cubit.close();

      await expectLater(pending, completes);
    });
  });
}
