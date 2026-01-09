import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import 'login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  Future<void> _startFlow() async {
    // Optional backend health check (non-blocking)
    try {
      await http
          .get(Uri.parse("$baseUrl/api/health"))
          .timeout(const Duration(seconds: 2));
    } catch (_) {}

    // Auto redirect (FASTER)
    Timer(const Duration(milliseconds: 1500), _goToLogin);
  }

  void _goToLogin() {
    if (_navigated || !mounted) return;
    _navigated = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,

        // ✅ SINGLE TAP ANYWHERE
        onTap: _goToLogin,

        // ✅ SWIPE STILL WORKS
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            _goToLogin();
          }
        },

        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // App Icon
                Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.monitor_heart,
                    size: 44,
                    color: AppColors.card,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Cardiopulmonary\nMonitor',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.card,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Continuous Health. Early Alerts.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.card.withOpacity(0.85),
                  ),
                ),

                const Spacer(),

                // Indicators (unchanged)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: index == 1 ? 16 : 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.card.withOpacity(
                          index == 1 ? 1 : 0.4,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
