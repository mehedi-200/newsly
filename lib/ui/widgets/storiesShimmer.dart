import 'package:flutter/material.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder list shown while the first page loads, sized like the real
/// [StoryTile] so nothing jumps when the data arrives.
class StoriesShimmer extends StatelessWidget {
  final int itemCount;

  const StoriesShimmer({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: customColors.shimmerBaseColor!,
          highlightColor: customColors.shimmerHighlightColor!,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: customColors.shimmerBaseColor,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
    );
  }
}
