import 'package:flutter/material.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';

class EmptyContainer extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyContainer({
    super.key,
    required this.message,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: customColors.subtitleColor),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: customColors.subtitleColor,
                ),
          ),
        ],
      ),
    );
  }
}
