import 'package:flutter/material.dart';
import 'package:newsly/data/models/comment.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:newsly/utils/utils.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _expanded = false;

  /// Past this depth the indent would eat the whole screen, so nesting stops
  /// growing visually even though the thread keeps going.
  static const int _maxIndentDepth = 6;
  static const double _indentWidth = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final text = Utils.stripHtml(widget.comment.text);
    final depth = widget.comment.depth.clamp(0, _maxIndentDepth);

    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: EdgeInsets.fromLTRB(16 + depth * _indentWidth, 12, 16, 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: customColors.dividerColor!, width: 0.6),
            left: depth == 0
                ? BorderSide.none
                : BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.comment.author ?? "",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  Utils.timeAgo(widget.comment.createdAt),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: customColors.subtitleColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              text,
              maxLines: _expanded ? null : 6,
              overflow: _expanded ? null : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
