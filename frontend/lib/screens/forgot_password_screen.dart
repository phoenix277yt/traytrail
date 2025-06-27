import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Forgot password screen for password recovery
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  /// Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Email must contain @';
    }
    return null;
  }

  /// Handle reset password button press
  void _handleResetPassword(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent'),
          backgroundColor: Color(0xFF3AB795), // Mint color for success
          duration: Duration(seconds: 3),
        ),
      );
      
      // Navigate back to login screen after delay
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reset password icon
                  Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'Enter your email address and we\'ll send you a link to reset your password.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Email field with Roboto font
                  TextFormField(
                    controller: emailController,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color(0xFF495867),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: const Icon(Icons.email),
                      labelStyle: GoogleFonts.roboto(
                        color: const Color(0xFF495867),
                      ),
                      hintStyle: GoogleFonts.roboto(
                        color: const Color(0xFF495867).withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Tomato-colored Reset Password ElevatedButton
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleResetPassword(context, formKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFE7252), // Tomato color
                        foregroundColor: Colors.white,
                        textStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reset Password'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Back to login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: const Color(0xFF495867),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFE7252), // Tomato color
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
