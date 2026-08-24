import 'package:flutter/material.dart';
import 'package:newsly/ui/styles/themeExtensions/customColorsExtension.dart';

class ErrorContainer extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorContainer({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 44,
              color: customColors.subtitleColor,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: customColors.subtitleColor,
                  ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
