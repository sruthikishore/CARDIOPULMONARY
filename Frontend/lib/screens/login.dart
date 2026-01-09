import 'package:flutter/material.dart';
import 'package:cardiopulmonary_monitor/screens/dashboard.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import '../core/theme/app_theme.dart';
import '../services/api_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  /// 🔹 LOGIN HANDLER (API CALL)
  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    try {
      // 🔴 MVP LOGIC:
      // For demo, we directly map login → user_id = 1
      // Later this can be replaced with real auth
      int userId = 1;

      final user = await ApiService.getUser(userId);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error. Please try again.")),
      );
    }

    setState(() => isLoading = false);
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
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.monitor_heart,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 16),

                // App Name
                Text(
                  'HealthCare Monitor',
                  style: AppTextStyles.section.copyWith(color: AppColors.card),
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
                            prefixIcon:
                                const Icon(Icons.email_outlined),
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
                            prefixIcon:
                                const Icon(Icons.lock_outline),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text('or',
                                  style: AppTextStyles.caption),
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
                                  builder: (_) =>
                                      DashboardScreen(userId: 1),
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
                                  style:
                                      AppTextStyles.caption.copyWith(
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
