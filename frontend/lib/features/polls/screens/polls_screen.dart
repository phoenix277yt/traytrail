import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/poll_option_card.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];
  
  // State for current poll voting
  String? _selectedPollOption;
  bool _hasVoted = false;
  
  // State for tomorrow's preferences
  final Set<String> _selectedBreakfastItems = {};
  final Set<String> _selectedLunchItems = {};

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create staggered animations for cards
    for (int i = 0; i < 4; i++) {
      final begin = i * 0.1;
      final end = 0.4 + (i * 0.1);
      
      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _staggerController,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        )),
      );

      _fadeAnimations.add(
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _staggerController,
          curve: Interval(begin, end, curve: Curves.easeInOut),
        )),
      );
    }

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Polls'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimations[0],
              child: FadeTransition(
                opacity: _fadeAnimations[0],
                child: _buildTomorrowPreferences(context),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            SlideTransition(
              position: _slideAnimations[1],
              child: FadeTransition(
                opacity: _fadeAnimations[1],
                child: _buildCurrentPoll(context),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            SlideTransition(
              position: _slideAnimations[2],
              child: FadeTransition(
                opacity: _fadeAnimations[2],
                child: _buildPollStats(context),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            SlideTransition(
              position: _slideAnimations[3],
              child: FadeTransition(
                opacity: _fadeAnimations[3],
                child: _buildPreviousWinners(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPoll(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Poll',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '5 days left',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Vote for your favorite item to be added to next month\'s menu!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PollOptionCard(
              name: 'Pav Bhaji',
              description: 'Spiced vegetable curry with bread rolls',
              percentage: 65,
              icon: Icons.local_dining,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              isLeading: true,
              isSelected: _selectedPollOption == 'Pav Bhaji',
              hasVoted: _hasVoted,
              onTap: () => _handlePollVote('Pav Bhaji'),
            ),
            const SizedBox(height: 16),
            PollOptionCard(
              name: 'Masala Dosa',
              description: 'Crispy rice crepe with potato filling',
              percentage: 45,
              icon: Icons.breakfast_dining,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              isLeading: false,
              isSelected: _selectedPollOption == 'Masala Dosa',
              hasVoted: _hasVoted,
              onTap: () => _handlePollVote('Masala Dosa'),
            ),
            const SizedBox(height: 16),
            PollOptionCard(
              name: 'Aloo Paratha',
              description: 'Stuffed flatbread with spiced potatoes',
              percentage: 38,
              icon: Icons.rice_bowl,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
              isLeading: false,
              isSelected: _selectedPollOption == 'Aloo Paratha',
              hasVoted: _hasVoted,
              onTap: () => _handlePollVote('Aloo Paratha'),
            ),
            const SizedBox(height: 16),
            PollOptionCard(
              name: 'Idli Sambar',
              description: 'Steamed rice cakes with lentil curry',
              percentage: 28,
              icon: Icons.breakfast_dining,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
              isLeading: false,
              isSelected: _selectedPollOption == 'Idli Sambar',
              hasVoted: _hasVoted,
              onTap: () => _handlePollVote('Idli Sambar'),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Votes: 342',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTomorrowPreferences(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tomorrow\'s Preferences',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'AI',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Help us prepare better! Select what you\'d like to eat tomorrow to reduce waste and ensure fresh meals.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Breakfast Section
            _buildMealSection(
              context,
              'Breakfast',
              Icons.wb_sunny,
              [
                _buildPreferenceOption(context, 'Poha', 'Current: 45 interested', 45, _selectedBreakfastItems.contains('Poha'), 'breakfast'),
                _buildPreferenceOption(context, 'Upma', 'Current: 32 interested', 32, _selectedBreakfastItems.contains('Upma'), 'breakfast'),
                _buildPreferenceOption(context, 'Idli Sambar', 'Current: 28 interested', 28, _selectedBreakfastItems.contains('Idli Sambar'), 'breakfast'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lunch Section  
            _buildMealSection(
              context,
              'Lunch',
              Icons.wb_sunny_outlined,
              [
                _buildPreferenceOption(context, 'Rajma Chawal', 'Current: 89 interested', 89, _selectedLunchItems.contains('Rajma Chawal'), 'lunch'),
                _buildPreferenceOption(context, 'Chole Bhature', 'Current: 67 interested', 67, _selectedLunchItems.contains('Chole Bhature'), 'lunch'),
                _buildPreferenceOption(context, 'Dal Tadka & Roti', 'Current: 54 interested', 54, _selectedLunchItems.contains('Dal Tadka & Roti'), 'lunch'),
                _buildPreferenceOption(context, 'Biryani', 'Current: 43 interested', 43, _selectedLunchItems.contains('Biryani'), 'lunch'),
              ],
            ),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedBreakfastItems.clear();
                        _selectedLunchItems.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'All preferences cleared!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Selections'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (_selectedBreakfastItems.isNotEmpty || _selectedLunchItems.isNotEmpty) ? () {
                      final totalSelected = _selectedBreakfastItems.length + _selectedLunchItems.length;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Successfully submitted $totalSelected preferences! Thank you for helping us plan better meals.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } : null,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Preferences'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String mealType, IconData icon, List<Widget> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mealType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(children: options),
      ],
    );
  }

  Widget _buildPreferenceOption(BuildContext context, String name, String subtitle, int count, bool isSelected, String mealType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
          : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? Icons.check : Icons.restaurant,
            size: 16,
            color: isSelected 
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              IconButton(
                onPressed: () {
                  setState(() {
                    if (mealType == 'breakfast') {
                      _selectedBreakfastItems.add(name);
                    } else {
                      _selectedLunchItems.add(name);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added $name to your preferences!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add to preferences',
              ),
          ],
        ),
        onTap: () {
          setState(() {
            if (mealType == 'breakfast') {
              if (isSelected) {
                _selectedBreakfastItems.remove(name);
              } else {
                _selectedBreakfastItems.add(name);
              }
            } else {
              if (isSelected) {
                _selectedLunchItems.remove(name);
              } else {
                _selectedLunchItems.add(name);
              }
            }
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildPollStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participation Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    '342',
                    'Total Votes',
                    Icons.how_to_vote,
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    '89%',
                    'Participation',
                    Icons.people,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    '12',
                    'Days Active',
                    Icons.calendar_today,
                    Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    // Use more saturated colors for better contrast
    Color saturatedColor;
    if (color == Theme.of(context).colorScheme.primaryContainer) {
      saturatedColor = Theme.of(context).colorScheme.primary;
    } else if (color == Theme.of(context).colorScheme.secondaryContainer) {
      saturatedColor = Theme.of(context).colorScheme.secondary;
    } else if (color == Theme.of(context).colorScheme.tertiaryContainer) {
      saturatedColor = Theme.of(context).colorScheme.tertiary;
    } else {
      saturatedColor = color;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: saturatedColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: saturatedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousWinners(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous Winners',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWinnerItem(context, 'Samosa Chaat', 'Last Month', '76% votes'),
            _buildWinnerItem(context, 'Butter Chicken', '2 months ago', '68% votes'),
            _buildWinnerItem(context, 'Vada Pav', '3 months ago', '82% votes'),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerItem(BuildContext context, String name, String period, String votes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  period,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            votes,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePollVote(String option) {
    if (!_hasVoted) {
      setState(() {
        _selectedPollOption = option;
        _hasVoted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Voted for $option! Thank you for participating.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
