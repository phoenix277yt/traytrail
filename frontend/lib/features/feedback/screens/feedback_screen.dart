import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/feedback_card.dart';
import '../widgets/feedback_form.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late TabController _tabController;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];
  
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Food Quality', 'Service', 'Suggestions', 'Complaints'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create staggered animations
    for (int i = 0; i < 6; i++) {
      final begin = i * 0.1;
      final end = 0.5 + (i * 0.1);
      
      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 0.3),
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feedback'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.forum), text: 'Forum'),
            Tab(icon: Icon(Icons.add_comment), text: 'Submit'),
          ],
        ),
      ),
      body: RepaintBoundary(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildForumTab(),
            _buildSubmitTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildForumTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RepaintBoundary(
            child: SlideTransition(
              position: _slideAnimations[0],
              child: FadeTransition(
                opacity: _fadeAnimations[0],
                child: _buildStatsOverview(),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          RepaintBoundary(
            child: SlideTransition(
              position: _slideAnimations[1],
              child: FadeTransition(
                opacity: _fadeAnimations[1],
                child: _buildCategoryFilter(),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          RepaintBoundary(
            child: SlideTransition(
              position: _slideAnimations[2],
              child: FadeTransition(
                opacity: _fadeAnimations[2],
                child: _buildRecentFeedback(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: RepaintBoundary(
        child: SlideTransition(
          position: _slideAnimations[0],
          child: FadeTransition(
            opacity: _fadeAnimations[0],
            child: const FeedbackForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Community Stats',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    '247',
                    'Total Feedback',
                    Icons.chat_bubble,
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    '89%',
                    'Response Rate',
                    Icons.trending_up,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    '32',
                    'Resolved',
                    Icons.check_circle,
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

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon, Color color) {
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
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: saturatedColor, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Feedback',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFeedbackList(),
      ],
    );
  }

  Widget _buildFeedbackList() {
    final feedbackItems = _getFilteredFeedback();
    
    return Column(
      children: feedbackItems.asMap().entries.map((entry) {
        final index = entry.key;
        final feedback = entry.value;
        final animIndex = (index + 3) % _slideAnimations.length;
        
        return SlideTransition(
          position: _slideAnimations[animIndex],
          child: FadeTransition(
            opacity: _fadeAnimations[animIndex],
            child: FeedbackCard(
              title: feedback['title']!,
              content: feedback['content']!,
              author: feedback['author']!,
              category: feedback['category']!,
              timestamp: feedback['timestamp']!,
              likes: feedback['likes'] as int,
              replies: feedback['replies'] as int,
              status: feedback['status']!,
              isLiked: feedback['isLiked'] as bool,
              onLike: () => _handleLike(index),
              onReply: () => _handleReply(index),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getFilteredFeedback() {
    final allFeedback = [
      {
        'title': 'Excellent Biryani Today!',
        'content': 'The chicken biryani served today was absolutely delicious. The spices were perfectly balanced and the rice was cooked just right.',
        'author': 'Priya S.',
        'category': 'Food Quality',
        'timestamp': '2 hours ago',
        'likes': 15,
        'replies': 3,
        'status': 'Acknowledged',
        'isLiked': false,
      },
      {
        'title': 'Suggestion for Breakfast Menu',
        'content': 'Could we have more South Indian options for breakfast? Maybe add dosa or uttapam to the weekly menu.',
        'author': 'Raj K.',
        'category': 'Suggestions',
        'timestamp': '5 hours ago',
        'likes': 8,
        'replies': 1,
        'status': 'Under Review',
        'isLiked': true,
      },
      {
        'title': 'Long Queue at Lunch',
        'content': 'The lunch queue was quite long today. Maybe we need better crowd management during peak hours.',
        'author': 'Anonymous',
        'category': 'Service',
        'timestamp': '1 day ago',
        'likes': 12,
        'replies': 2,
        'status': 'Resolved',
        'isLiked': false,
      },
      {
        'title': 'Vegetarian Options',
        'content': 'Really appreciate the variety in vegetarian dishes. The paneer curry yesterday was fantastic!',
        'author': 'Meera L.',
        'category': 'Food Quality',
        'timestamp': '2 days ago',
        'likes': 20,
        'replies': 4,
        'status': 'Acknowledged',
        'isLiked': true,
      },
      {
        'title': 'Temperature Issue',
        'content': 'The food was a bit cold when I got it. Perhaps the heating trays need checking.',
        'author': 'Amit P.',
        'category': 'Complaints',
        'timestamp': '3 days ago',
        'likes': 6,
        'replies': 1,
        'status': 'Resolved',
        'isLiked': false,
      },
    ];

    if (_selectedCategory == 'All') {
      return allFeedback;
    }
    
    return allFeedback.where((item) => item['category'] == _selectedCategory).toList();
  }

  void _handleLike(int index) {
    setState(() {
      // Toggle like status - in a real app, this would update the backend
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you for your interaction!',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleReply(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reply to Feedback',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Type your reply here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reply posted successfully!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Post Reply'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
