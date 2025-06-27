import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Feedback screen for user feedback and reviews
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 0; // 0 means no rating selected
  
  // Maximum character limit for comments
  static const int _maxCommentLength = 200;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Handle star rating tap
  void _onStarTapped(int starIndex) {
    setState(() {
      _rating = starIndex + 1; // Convert 0-based index to 1-5 rating
    });
  }

  /// Validate comment field
  String? _validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your feedback';
    }
    if (value.length > _maxCommentLength) {
      return 'Comment must be $_maxCommentLength characters or less';
    }
    return null;
  }

  /// Handle submit button press
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      if (_rating == 0) {
        // Show error if no rating selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a rating'),
            backgroundColor: Color(0xFFBA1A1A), // Error color
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted'),
          backgroundColor: Color(0xFF3AB795), // Mint color for success
          duration: Duration(seconds: 2),
        ),
      );

      // Reset form after submission (optional)
      setState(() {
        _rating = 0;
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Feedback title and description
              Text(
                'We Value Your Feedback',
                style: GoogleFonts.zenLoop(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF495867), // Payne's Gray
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Help us improve TrayTrail by sharing your experience and suggestions.',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  color: const Color(0xFF495867).withValues(alpha: 0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Rating section
              _RatingSection(
                rating: _rating,
                onStarTapped: _onStarTapped,
              ),
              const SizedBox(height: 32),
              
              // Comments section
              _CommentsSection(
                controller: _commentController,
                validator: _validateComment,
                maxLength: _maxCommentLength,
              ),
              const SizedBox(height: 32),
              
              // Submit button
              _SubmitButton(
                onPressed: _submitFeedback,
                hasRating: _rating > 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rating section with 5-star system
class _RatingSection extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onStarTapped;

  const _RatingSection({
    required this.rating,
    required this.onStarTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate Your Experience',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF495867),
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF8B7D7A).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Star rating row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => onStarTapped(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: index < rating
                            ? const Color(0xFFFE7252) // Tomato color for filled stars
                            : const Color(0xFF8B7D7A).withValues(alpha: 0.3), // Gray for empty stars
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              
              // Rating description
              Text(
                _getRatingDescription(rating),
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  color: const Color(0xFF495867).withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get description text for current rating
  String _getRatingDescription(int rating) {
    switch (rating) {
      case 1:
        return 'Poor - We need to improve';
      case 2:
        return 'Fair - Below expectations';
      case 3:
        return 'Good - Meets expectations';
      case 4:
        return 'Very Good - Above expectations';
      case 5:
        return 'Excellent - Outstanding experience!';
      default:
        return 'Tap stars to rate your experience';
    }
  }
}

/// Comments section with text field
class _CommentsSection extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final int maxLength;

  const _CommentsSection({
    required this.controller,
    required this.validator,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Comments',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF495867),
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          maxLines: 5,
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: const Color(0xFF495867),
          ),
          decoration: InputDecoration(
            hintText: 'Share your thoughts, suggestions, or any issues you encountered...',
            hintStyle: GoogleFonts.roboto(
              color: const Color(0xFF495867).withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF8B7D7A).withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF8B7D7A).withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFE7252), // Tomato color
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFBA1A1A), // Error color
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFBA1A1A), // Error color
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            counterStyle: GoogleFonts.roboto(
              fontSize: 12,
              color: const Color(0xFF495867).withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

/// Submit button widget
class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasRating;

  const _SubmitButton({
    required this.onPressed,
    required this.hasRating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFE7252), // Tomato color
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.send,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Submit Feedback'),
          ],
        ),
      ),
    );
  }
}
