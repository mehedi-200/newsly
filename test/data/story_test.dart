import 'package:flutter_test/flutter_test.dart';
import 'package:newsly/data/models/comment.dart';
import 'package:newsly/data/models/storiesResponse.dart';
import 'package:newsly/data/models/story.dart';

void main() {
  group('Story.fromJson', () {
    test('reads the fields the Algolia API actually returns', () {
      final story = Story.fromJson({
        'objectID': '16582136',
        'title': 'Stephen Hawking has died',
        'url': 'http://www.bbc.com/news/uk-43396008',
        'author': 'Cogito',
        'points': 4271,
        'num_comments': 484,
        'created_at': '2018-03-14T03:51:29Z',
      });

      expect(story.id, '16582136');
      expect(story.title, 'Stephen Hawking has died');
      expect(story.author, 'Cogito');
      expect(story.points, 4271);
      expect(story.commentsCount, 484);
      expect(story.isSelfPost, isFalse);
    });

    test('treats a story with no url as a self post', () {
      final story = Story.fromJson({
        'objectID': '37392676',
        'title': 'Ask HN: something',
        'url': null,
        'story_text': 'body',
      });

      expect(story.isSelfPost, isTrue);
      expect(
          story.openableUrl, contains('news.ycombinator.com/item?id=37392676'));
    });

    test('survives a response missing every optional field', () {
      final story = Story.fromJson({'objectID': '1'});

      expect(story.points, 0);
      expect(story.commentsCount, 0);
      expect(story.title, isNull);
    });

    test('round-trips through toJson so bookmarks reload intact', () {
      final original = Story.fromJson({
        'objectID': '42',
        'title': 'Title',
        'url': 'https://example.com/a',
        'author': 'me',
        'points': 7,
        'num_comments': 3,
        'created_at': '2024-01-01T00:00:00Z',
      });

      final restored = Story.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.points, original.points);
      expect(restored.commentsCount, original.commentsCount);
    });
  });

  group('StoriesResponse', () {
    test('drops hits with no title and reports pagination', () {
      final response = StoriesResponse.fromJson({
        'hits': [
          {'objectID': '1', 'title': 'Kept'},
          {'objectID': '2', 'title': null},
        ],
        'page': 2,
        'nbPages': 5,
      });

      expect(response.stories.length, 1);
      expect(response.currentPage, 2);
      expect(response.hasMore, isTrue);
    });

    test('hasMore is false on the last page', () {
      final response = StoriesResponse.fromJson({
        'hits': [],
        'page': 4,
        'nbPages': 5,
      });

      expect(response.hasMore, isFalse);
    });
  });

  group('Comment', () {
    test('flattens a nested thread depth-first with increasing depth', () {
      final comment = Comment.fromJson({
        'id': 1,
        'author': 'a',
        'text': 'root',
        'children': [
          {
            'id': 2,
            'author': 'b',
            'text': 'reply',
            'children': [
              {'id': 3, 'author': 'c', 'text': 'nested', 'children': []},
            ],
          },
        ],
      });

      final flattened = comment.flattened();

      expect(flattened.map((c) => c.id).toList(), ['1', '2', '3']);
      expect(flattened.map((c) => c.depth).toList(), [0, 1, 2]);
    });

    test('skips deleted comments but keeps their replies', () {
      final comment = Comment.fromJson({
        'id': 1,
        'author': null,
        'text': null,
        'children': [
          {'id': 2, 'author': 'b', 'text': 'still here', 'children': []},
        ],
      });

      final flattened = comment.flattened();

      expect(flattened.length, 1);
      expect(flattened.single.id, '2');
    });
  });
}
