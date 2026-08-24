import 'package:newsly/data/models/comment.dart';
import 'package:newsly/data/models/storiesResponse.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/utils/api.dart';
import 'package:newsly/utils/constants.dart';

class StoryRepository {
  Future<StoriesResponse> getStories({
    required StoryFeed feed,
    required int page,
  }) async {
    try {
      final result = await Api.get(
        url: feed.sortByDate ? Api.searchByDate : Api.search,
        queryParameters: {
          'tags': feed.tag,
          'page': page,
          'hitsPerPage': storiesPerPage,
          //Dio percent-encodes the '>' for us.
          if (feed.createdAfterFilter != null)
            'numericFilters': feed.createdAfterFilter,
        },
      );

      return StoriesResponse.fromJson(result);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<StoriesResponse> searchStories({
    required String query,
    required int page,
  }) async {
    try {
      final result = await Api.get(
        url: Api.search,
        queryParameters: {
          'query': query,
          'tags': 'story',
          'page': page,
          'hitsPerPage': storiesPerPage,
        },
      );

      return StoriesResponse.fromJson(result);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// The comment thread for a story. `items/<id>` returns the whole tree in one
  /// call, so it is fetched once and flattened for display.
  Future<List<Comment>> getComments({required String storyId}) async {
    try {
      final result = await Api.get(url: "${Api.item}/$storyId");

      return ((result['children'] ?? []) as List)
          .map((child) =>
              Comment.fromJson(Map<String, dynamic>.from(child ?? {})))
          .expand((comment) => comment.flattened())
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
