import 'package:newsly/utils/constants.dart';

class Story {
  final String id;
  final String? title;
  final String? url;
  final String? author;
  final int points;
  final int commentsCount;
  final String? createdAt;
  final String? text;

  const Story({
    required this.id,
    this.title,
    this.url,
    this.author,
    this.points = 0,
    this.commentsCount = 0,
    this.createdAt,
    this.text,
  });

  Story.fromJson(Map<String, dynamic> json)
      : id = (json['objectID'] ?? '').toString(),
        title = (json['title'] ?? json['story_title']) as String?,
        url = (json['url'] ?? json['story_url']) as String?,
        author = json['author'] as String?,
        points = (json['points'] ?? 0) as int,
        commentsCount = (json['num_comments'] ?? 0) as int,
        createdAt = json['created_at'] as String?,
        text = json['story_text'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'objectID': id,
      'title': title,
      'url': url,
      'author': author,
      'points': points,
      'num_comments': commentsCount,
      'created_at': createdAt,
      'story_text': text,
    };
  }

  /// Ask HN / Show HN posts have no external link — they live on HN itself.
  bool get isSelfPost => url == null || url!.isEmpty;

  /// The link to open when the user taps the story: the article if there is
  /// one, otherwise the HN discussion page.
  String get openableUrl => isSelfPost ? "$hackerNewsItemUrl$id" : url!;

  String get discussionUrl => "$hackerNewsItemUrl$id";
}
