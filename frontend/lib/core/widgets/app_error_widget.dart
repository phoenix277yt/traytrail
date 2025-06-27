import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Custom error widget for better error handling
class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const AppErrorWidget({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        color: AppColors.lightColorScheme.errorContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.lightColorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: AppTypography.buildTextTheme().headlineSmall?.copyWith(
                color: AppColors.lightColorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re sorry for the inconvenience. Please try again.',
              style: AppTypography.buildTextTheme().bodyMedium?.copyWith(
                color: AppColors.lightColorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Information:',
                      style: AppTypography.buildTextTheme().labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightColorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorDetails.exception.toString(),
                      style: AppTypography.buildTextTheme().bodySmall?.copyWith(
                        fontFamily: 'Courier',
                        color: AppColors.lightColorScheme.onErrorContainer,
                      ),
                    ),
                    if (errorDetails.stack != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Stack trace:',
                        style: AppTypography.buildTextTheme().labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightColorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        errorDetails.stack.toString(),
                        style: AppTypography.buildTextTheme().bodySmall?.copyWith(
                          fontFamily: 'Courier',
                          color: AppColors.lightColorScheme.onErrorContainer,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // You can add restart logic here
                // or navigate back to a safe screen
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/splash',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightColorScheme.primary,
                foregroundColor: AppColors.lightColorScheme.onPrimary,
              ),
              child: const Text('Restart App'),
            ),
          ],
        ),
      ),
    );
  }
}
