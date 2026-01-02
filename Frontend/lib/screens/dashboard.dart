import 'package:cardiopulmonary_monitor/screens/profile.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import 'risk_analysis.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      // ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RiskAnalysisScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Risk'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.menu, color: AppColors.card),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cardiopulmonary Monitor',
                          style: AppTextStyles.section.copyWith(
                            color: AppColors.card,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Continuous Health. Early Alerts.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.card.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: AppColors.card),
                ],
              ),
            ),

            // ================= USER GREETING =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.card,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.card.withOpacity(0.85),
                        ),
                      ),
                      Text(
                        'Alex Johnson',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.card,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= STATUS CARD =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Systems Normal',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Last updated: 2 min ago',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= SCROLLABLE LIVE VITALS =================
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Live Vitals', style: AppTextStyles.section),
                      SizedBox(height: 16),

                      VitalCardExact(
                        title: 'Heart Rate',
                        subtitle: 'Beats per minute',
                        value: '72',
                        unit: 'bpm',
                        range: '60–100 bpm',
                        status: 'Normal',
                        trend: '+2%',
                        color: AppColors.danger,
                        icon: Icons.favorite,
                      ),

                      VitalCardExact(
                        title: 'Blood Oxygen',
                        subtitle: 'SpO₂ saturation',
                        value: '98',
                        unit: '%',
                        range: '95–100%',
                        status: 'Excellent',
                        trend: '0%',
                        color: AppColors.primary,
                        icon: Icons.water_drop,
                      ),

                      VitalCardExact(
                        title: 'Respiration Rate',
                        subtitle: 'Breaths per minute',
                        value: '16',
                        unit: 'rpm',
                        range: '12–20 rpm',
                        status: 'Normal',
                        trend: '-1%',
                        color: AppColors.success,
                        icon: Icons.air,
                      ),

                      // SAFE bottom padding (prevents nav overlap)
                      SizedBox(height: 24),
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
}

class VitalCardExact extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final String range;
  final String status;
  final String trend;
  final Color color;
  final IconData icon;

  const VitalCardExact({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.range,
    required this.status,
    required this.trend,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.body),
                        Text(subtitle, style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
                Text(
                  trend,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // VALUE
            RichText(
              text: TextSpan(
                text: value,
                style: AppTextStyles.vitals.copyWith(color: color),
                children: [
                  TextSpan(text: ' $unit', style: AppTextStyles.caption),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Range\n$range', style: AppTextStyles.caption),
                Text(
                  'Status\n$status',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
