import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/utils/hiveBoxKeys.dart';

/// Saved stories, keyed by story id so a toggle is a single box operation.
class BookmarkRepository {
  Box get _box => Hive.box(bookmarksBoxKey);

  List<Story> getBookmarks() {
    return _box.values
        .map((value) => Story.fromJson(Map<String, dynamic>.from(value as Map)))
        .toList()
        .reversed //most recently saved first
        .toList();
  }

  bool isBookmarked(String storyId) => _box.containsKey(storyId);

  Future<void> addBookmark(Story story) async {
    await _box.put(story.id, story.toJson());
  }

  Future<void> removeBookmark(String storyId) async {
    await _box.delete(storyId);
  }

  Future<void> clearBookmarks() async {
    await _box.clear();
  }
}
