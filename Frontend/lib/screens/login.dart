import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cardiopulmonary_monitor/screens/dashboard.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import '../core/theme/app_theme.dart';
import '../core/network/api_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  /// 🔹 LOGIN HANDLER (DB‑CONNECTED, MVP SAFE)
  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    try {
      // 🔴 MVP decision (as discussed)
      // Login always maps to user_id = 1 for now
      final int userId = 1;

      final response = await http.get(
        Uri.parse(ApiConfig.users(userId)),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final user = jsonDecode(response.body);

        if (!mounted) return;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardScreen(userId: userId),
            ),
          );
        } else {
          _showError("Invalid credentials");
        }
      } else {
        _showError("User not found");
      }
    } catch (e) {
      _showError("Server error. Please try again.");
    }

    setState(() => isLoading = false);
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // App Icon
                Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 92,
                      height: 92,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // App Name
                Text(
                  'Vitals AI',
                  style: AppTextStyles.section.copyWith(
                    color: AppColors.card,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Welcome back',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.card.withOpacity(0.85),
                  ),
                ),

                const SizedBox(height: 32),

                // Login Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign In', style: AppTextStyles.section),

                        const SizedBox(height: 20),

                        // Email
                        Text('Email Address', style: AppTextStyles.caption),
                        const SizedBox(height: 6),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'your.email@example.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password
                        Text('Password', style: AppTextStyles.caption),
                        const SizedBox(height: 6),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon:
                                const Icon(Icons.visibility_off_outlined),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isLoading ? null : handleLogin,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Sign In',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.card,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // OR Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'or',
                                style: AppTextStyles.caption,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Guest Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DashboardScreen(userId: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_outline),
                            label: Text(
                              'Continue as Guest',
                              style: AppTextStyles.body,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sign Up
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: AppTextStyles.caption,
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer
                Text(
                  'Privacy Policy   |   Terms of Service',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.card.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '© 2024 HealthCare Monitor. All rights reserved.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.card.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
