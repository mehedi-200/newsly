import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/data/models/story.dart';
import 'package:newsly/data/repositories/bookmarkRepository.dart';

class BookmarksState {
  final List<Story> stories;

  const BookmarksState(this.stories);
}

/// App-wide, provided once in [MyApp] — the story tile, the details screen and
/// the bookmarks tab all read the same list.
class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarkRepository _bookmarkRepository;

  BookmarksCubit({BookmarkRepository? bookmarkRepository})
      : _bookmarkRepository = bookmarkRepository ?? BookmarkRepository(),
        super(const BookmarksState([])) {
    _load();
  }

  void _load() => emit(BookmarksState(_bookmarkRepository.getBookmarks()));

  bool isBookmarked(String storyId) =>
      state.stories.any((story) => story.id == storyId);

  /// Returns true if the story ended up saved, so the caller can show the
  /// right confirmation.
  Future<bool> toggleBookmark(Story story) async {
    final wasBookmarked = isBookmarked(story.id);

    if (wasBookmarked) {
      await _bookmarkRepository.removeBookmark(story.id);
    } else {
      await _bookmarkRepository.addBookmark(story);
    }

    _load();
    return !wasBookmarked;
  }

  Future<void> clearAll() async {
    await _bookmarkRepository.clearBookmarks();
    _load();
  }
}
