import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/state/state.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/screens/onboarding_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPrefs = ref.watch(userPreferencesProvider);
    final themePrefs = ref.watch(themePreferencesProvider);
    final notificationPrefs = ref.watch(notificationPreferencesProvider);
    final foodPrefs = ref.watch(foodPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildSection(
            context,
            'Theme & Display',
            [
              _buildSliderTile(
                context,
                'Text Scale',
                themePrefs.textScale,
                0.8,
                1.5,
                (value) => ref.read(userPreferencesProvider.notifier).setTextScale(value),
                Icons.text_fields,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.largePadding),
          
          _buildSection(
            context,
            'Notifications',
            [
              _buildSwitchTile(
                context,
                'Enable Notifications',
                notificationPrefs.enabled,
                (value) => ref.read(userPreferencesProvider.notifier).setNotificationsEnabled(value),
                Icons.notifications,
              ),
              _buildSwitchTile(
                context,
                'Menu Updates',
                notificationPrefs.menuUpdates,
                (value) => ref.read(userPreferencesProvider.notifier).setMenuUpdatesEnabled(value),
                Icons.restaurant_menu,
                enabled: notificationPrefs.enabled,
              ),
              _buildSwitchTile(
                context,
                'Poll Notifications',
                notificationPrefs.pollNotifications,
                (value) => ref.read(userPreferencesProvider.notifier).setPollNotificationsEnabled(value),
                Icons.poll,
                enabled: notificationPrefs.enabled,
              ),
              _buildSwitchTile(
                context,
                'Feedback Responses',
                notificationPrefs.feedbackResponses,
                (value) => ref.read(userPreferencesProvider.notifier).setFeedbackResponsesEnabled(value),
                Icons.feedback,
                enabled: notificationPrefs.enabled,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.largePadding),
          
          _buildSection(
            context,
            'Food Preferences',
            [
              _buildSliderTile(
                context,
                'Spice Preference',
                foodPrefs.spicePreference.toDouble(),
                0,
                5,
                (value) => ref.read(userPreferencesProvider.notifier).setSpicePreference(value.round()),
                Icons.local_fire_department,
                divisions: 5,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.largePadding),
          
          _buildSection(
            context,
            'Data & Storage',
            [
              _buildListTile(
                context,
                'Clear All Data',
                'Reset app to defaults',
                Icons.delete_forever,
                () => _showResetDialog(context, ref),
                textColor: Theme.of(context).colorScheme.error,
              ),
              _buildListTile(
                context,
                'Export Data',
                'Download your preferences',
                Icons.download,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.largePadding),
          
          _buildSection(
            context,
            'Help & Support',
            [
              _buildListTile(
                context,
                'View App Introduction',
                'See the onboarding tutorial again',
                Icons.help_outline,
                () => _showOnboarding(context),
              ),
              _buildListTile(
                context,
                'Contact Support',
                'Get help with the app',
                Icons.contact_support,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Support feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.largePadding),
          
          // User info display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text('User ID: ${userPrefs.userId.isEmpty ? 'Not set' : userPrefs.userId}'),
                  Text('Username: ${userPrefs.username.isEmpty ? 'Not set' : userPrefs.username}'),
                  Text('Email: ${userPrefs.email.isEmpty ? 'Not set' : userPrefs.email}'),
                  Text('First time user: ${userPrefs.isFirstTime ? 'Yes' : 'No'}'),
                  Text('Last updated: ${userPrefs.lastUpdated.toString().split('.')[0]}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOnboarding(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: TrayTrailColors.tomatoSaturated,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon, {
    bool enabled = true,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: enabled ? onChanged : null,
      secondary: Icon(icon),
      activeColor: TrayTrailColors.tomatoSaturated,
      activeTrackColor: TrayTrailColors.tomatoSaturated.withValues(alpha: 0.5),
    );
  }

  Widget _buildSliderTile(
    BuildContext context,
    String title,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    IconData icon, {
    int? divisions,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Value: ${value.toStringAsFixed(1)}'),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: TrayTrailColors.tomatoSaturated,
              thumbColor: TrayTrailColors.tomatoSaturated,
              overlayColor: TrayTrailColors.tomatoSaturated.withValues(alpha: 0.1),
              valueIndicatorColor: TrayTrailColors.tomatoSaturated,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _showResetDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
          'This will reset all your preferences and data to defaults. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(userPreferencesProvider.notifier).resetToDefaults();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data has been reset to defaults')),
        );
      }
    }
  }
}
