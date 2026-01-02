import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';

class RiskAnalysisScreen extends StatelessWidget {
  const RiskAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      // ===== BOTTOM NAV (PRESENT IN IMAGE) =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        showSelectedLabels: true,
          showUnselectedLabels: true,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Risk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: AppColors.card),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Risk Analysis',
                        style: AppTextStyles.section.copyWith(
                          color: AppColors.card,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.more_vert, color: AppColors.card),
                ],
              ),
            ),

            // ================= SCROLLABLE WHITE BODY =================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // ===== CURRENT RISK CARD =====
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.success,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shield,
                                  color: AppColors.success,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Current Risk Level',
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'NORMAL',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.card,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Confidence
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Confidence Level',
                                    style: AppTextStyles.caption,
                                  ),
                                  Text(
                                    '94%',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: 0.94,
                                  minHeight: 6,
                                  backgroundColor:
                                      AppColors.background,
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                    AppColors.success,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // All Systems Normal
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.success
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: const BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: AppColors.card,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'All Systems Normal',
                                            style: AppTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Your cardiopulmonary metrics are within healthy ranges. Heart rate, oxygen levels, and respiratory patterns show no concerning variations.',
                                            style: AppTextStyles.caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== MINI VITALS =====
                      _miniVital(
                          Icons.favorite, 'Heart Rate', '72 bpm'),
                      _miniVital(Icons.water_drop,
                          'Oxygen Saturation', '98 %'),
                      _miniVital(Icons.air,
                          'Respiratory Rate', '16 br/min'),

                      const SizedBox(height: 16),

                      // ===== RECENT ALERTS =====
                      _sectionHeader('Recent Alerts'),
                      _alertItem(
                        Icons.info,
                        'System Check Complete',
                        'All metrics analyzed successfully',
                        '2 hours ago',
                      ),
                      _alertItem(
                        Icons.check_circle,
                        'Vitals Within Range',
                        'No abnormalities detected',
                        '5 hours ago',
                      ),

                      const SizedBox(height: 16),

                      // ===== UNDERSTANDING RISK =====
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb,
                                      color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Understanding Risk Levels',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _bullet(AppColors.success,
                                  'Normal: All vitals stable'),
                              _bullet(AppColors.warning,
                                  'Moderate: Minor variations detected'),
                              _bullet(AppColors.danger,
                                  'High: Immediate attention needed'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _miniVital(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.success),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body),
                  Text(value, style: AppTextStyles.caption),
                ],
              ),
            ),
            Row(
              children: const [
                Text('Normal',
                    style: AppTextStyles.caption),
                SizedBox(width: 6),
                Icon(Icons.check_circle,
                    color: AppColors.success, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.section),
          Text('View All',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
              )),
        ],
      ),
    );
  }

  Widget _alertItem(
      IconData icon, String title, String desc, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                Text(desc, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _bullet(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.caption)),
        ],
      ),
    );
  }
}
