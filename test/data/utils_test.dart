import 'package:flutter_test/flutter_test.dart';
import 'package:newsly/data/models/storyFeed.dart';
import 'package:newsly/utils/utils.dart';

void main() {
  group('Utils.domainOf', () {
    test('strips the scheme, path and www prefix', () {
      expect(Utils.domainOf('https://www.bbc.com/news/uk-43396008'), 'bbc.com');
      expect(
          Utils.domainOf('https://github.com/flutter/flutter'), 'github.com');
    });

    test('returns an empty string for null or unusable input', () {
      expect(Utils.domainOf(null), '');
      expect(Utils.domainOf(''), '');
      expect(Utils.domainOf('not a url'), '');
    });
  });

  group('Utils.stripHtml', () {
    test('unwraps the tags and entities HN comment bodies use', () {
      expect(
        Utils.stripHtml('<p>It&#x27;s <i>fine</i> &amp; short</p>'),
        "It's fine & short",
      );
    });

    test('returns an empty string for null', () {
      expect(Utils.stripHtml(null), '');
    });
  });

  group('StoryFeed', () {
    test('only the New tab uses the chronological endpoint', () {
      expect(StoryFeed.latest.sortByDate, isTrue);
      expect(StoryFeed.top.sortByDate, isFalse);
    });

    test('popularity feeds carry a recency cut-off, New does not', () {
      expect(StoryFeed.top.createdAfterFilter, startsWith('created_at_i>'));
      expect(StoryFeed.latest.createdAfterFilter, isNull);
    });
  });
}
