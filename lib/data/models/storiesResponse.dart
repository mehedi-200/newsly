import 'package:newsly/data/models/story.dart';

class StoriesResponse {
  final List<Story> stories;
  final int currentPage;
  final int totalPages;

  const StoriesResponse({
    required this.stories,
    required this.currentPage,
    required this.totalPages,
  });

  StoriesResponse.fromJson(Map<String, dynamic> json)
      : stories = ((json['hits'] ?? []) as List)
            .map((hit) => Story.fromJson(Map<String, dynamic>.from(hit ?? {})))
            .where((story) => story.title != null && story.id.isNotEmpty)
            .toList(),
        currentPage = (json['page'] ?? 0) as int,
        totalPages = (json['nbPages'] ?? 0) as int;

  bool get hasMore => currentPage + 1 < totalPages;
}
