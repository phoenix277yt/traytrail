import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Signup screen for user registration
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _selectedRole;

  final List<String> _roles = ['student', 'parent', 'teacher', 'staff'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validate name field
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

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

  /// Validate password length
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate role selection
  String? _validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your role';
    }
    return null;
  }

  /// Handle signup button press
  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful'),
          backgroundColor: Color(0xFF3AB795), // Mint color for success
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navigate to login screen after delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome message
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join TrayTrail and start your food journey',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Name field with Roboto font
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xFF495867),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person),
                    labelStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867),
                    ),
                    hintStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867).withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Email field with Roboto font
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xFF495867),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    labelStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867),
                    ),
                    hintStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867).withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Password field with Roboto font
                TextFormField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xFF495867),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867),
                    ),
                    hintStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867).withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Role dropdown field
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  validator: _validateRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xFF495867),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    hintText: 'Select your role',
                    prefixIcon: const Icon(Icons.work),
                    labelStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867),
                    ),
                    hintStyle: GoogleFonts.roboto(
                      color: const Color(0xFF495867).withValues(alpha: 0.6),
                    ),
                  ),
                  items: _roles.map<DropdownMenuItem<String>>((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: const Color(0xFF495867),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                
                // Tomato-colored Sign Up ElevatedButton
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
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
                    child: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Sign In navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: const Color(0xFF495867),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
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
    );
  }
}
