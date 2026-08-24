import 'package:flutter/material.dart';

/// Colors that don't map onto a Material [ColorScheme] slot but still need to
/// change with the theme. Read them with
/// `Theme.of(context).extension<CustomColors>()!`.
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? successColor;
  final Color? upvoteColor;
  final Color? subtitleColor;
  final Color? dividerColor;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  const CustomColors({
    required this.successColor,
    required this.upvoteColor,
    required this.subtitleColor,
    required this.dividerColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? successColor,
    Color? upvoteColor,
    Color? subtitleColor,
    Color? dividerColor,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
  }) {
    return CustomColors(
      successColor: successColor ?? this.successColor,
      upvoteColor: upvoteColor ?? this.upvoteColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      dividerColor: dividerColor ?? this.dividerColor,
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor:
          shimmerHighlightColor ?? this.shimmerHighlightColor,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      successColor: Color.lerp(successColor, other.successColor, t),
      upvoteColor: Color.lerp(upvoteColor, other.upvoteColor, t),
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      shimmerBaseColor: Color.lerp(shimmerBaseColor, other.shimmerBaseColor, t),
      shimmerHighlightColor:
          Color.lerp(shimmerHighlightColor, other.shimmerHighlightColor, t),
    );
  }
}
