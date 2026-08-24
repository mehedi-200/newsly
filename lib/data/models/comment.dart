class Comment {
  final String id;
  final String? author;
  final String? text;
  final String? createdAt;
  final List<Comment> children;

  /// How deep this comment sits in the thread. Set while flattening, not by
  /// the API — the UI uses it to indent replies.
  final int depth;

  const Comment({
    required this.id,
    this.author,
    this.text,
    this.createdAt,
    this.children = const [],
    this.depth = 0,
  });

  factory Comment.fromJson(Map<String, dynamic> json, {int depth = 0}) {
    return Comment(
      id: (json['id'] ?? '').toString(),
      author: json['author'] as String?,
      text: json['text'] as String?,
      createdAt: json['created_at'] as String?,
      depth: depth,
      children: ((json['children'] ?? []) as List)
          .map((child) => Comment.fromJson(
              Map<String, dynamic>.from(child ?? {}),
              depth: depth + 1))
          .toList(),
    );
  }

  /// Deleted comments come back with a null author and null text. They still
  /// carry replies, so they are kept in the tree but not rendered.
  bool get isDeleted => author == null || text == null;

  /// Depth-first flatten so the thread can be rendered by a single ListView
  /// instead of nested scrollables.
  List<Comment> flattened() {
    return [
      if (!isDeleted) this,
      ...children.expand((child) => child.flattened()),
    ];
  }
}
