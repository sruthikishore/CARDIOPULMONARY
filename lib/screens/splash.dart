import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import '../core/theme/app_theme.dart';

// 👉 Replace this import with your actual next screen file
import 'login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
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

                // App Icon Circle
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

                // Page Indicators
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
