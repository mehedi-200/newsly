import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class Utils {
  /// "3 hours ago" from the API's ISO-8601 `created_at`.
  static String timeAgo(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return "";
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) return "";
    return timeago.format(parsed.toLocal());
  }

  /// "github.com" from "https://github.com/flutter/flutter" — the little
  /// source label under a story title.
  static String domainOf(String? url) {
    if (url == null || url.isEmpty) return "";
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return "";
    return uri.host.replaceFirst("www.", "");
  }

  /// Comment bodies come back as a small subset of HTML. Rendering a full HTML
  /// engine for `<p>` and `<i>` is overkill, so unwrap the tags we actually see.
  static String stripHtml(String? html) {
    if (html == null || html.isEmpty) return "";
    return html
        .replaceAll(RegExp(r"<p>"), "\n\n")
        .replaceAll(RegExp(r"<[^>]*>"), "")
        .replaceAll("&#x27;", "'")
        .replaceAll("&#x2F;", "/")
        .replaceAll("&quot;", '"')
        .replaceAll("&amp;", "&")
        .replaceAll("&gt;", ">")
        .replaceAll("&lt;", "<")
        .trim();
  }

  static Future<void> openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
