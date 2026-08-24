import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:newsly/app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static Widget getRouteInstance() => const SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Get.offAllNamed(Routes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, size: 64, color: theme.colorScheme.primary)
                .animate()
                .scale(duration: 500.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 12),
            Text(
              "Newsly",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
            const SizedBox(height: 6),
            Text(
              "Hacker News, quietly",
              style: theme.textTheme.bodySmall,
            ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
