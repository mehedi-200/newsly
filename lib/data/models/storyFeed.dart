/// The four tabs on the home screen. Each maps to an Algolia `tags` filter.
enum StoryFeed {
  top(label: "Top", tag: "story", recentWindow: Duration(days: 7)),
  latest(label: "New", tag: "story"),
  ask(label: "Ask HN", tag: "ask_hn", recentWindow: Duration(days: 30)),
  show(label: "Show HN", tag: "show_hn", recentWindow: Duration(days: 30));

  const StoryFeed({
    required this.label,
    required this.tag,
    this.recentWindow,
  });

  final String label;
  final String tag;

  /// How far back a popularity-ranked feed is allowed to reach. Without this
  /// the API happily returns all-time classics from 2018 — correct by points,
  /// useless as a news feed. Null means no cut-off.
  final Duration? recentWindow;

  /// `search` ranks by popularity, `search_by_date` by recency. Only the "New"
  /// tab wants the chronological endpoint.
  bool get sortByDate => this == StoryFeed.latest;

  /// Algolia's numeric filter over the story's unix timestamp, or null when
  /// the feed has no cut-off.
  String? get createdAfterFilter {
    if (recentWindow == null) return null;
    final cutoff = DateTime.now().subtract(recentWindow!);
    return "created_at_i>${cutoff.millisecondsSinceEpoch ~/ 1000}";
  }
}
