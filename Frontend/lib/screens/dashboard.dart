import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import 'risk_analysis.dart';
import 'profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;

  const DashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  int heartRate = 0;
  int spo2 = 0;
  int respiration = 0;
  double temperature = 0.0;

  // ⚠️ CHANGE THIS TO YOUR SYSTEM IP
  static final String baseUrl = dotenv.env['BASE_URL']!;
  final int userId = 1; // dummy user for now

  @override
  void initState() {
    super.initState();
    fetchLatestVitals();
  }

  Future<void> fetchLatestVitals() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/vitals/latest/$userId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          heartRate = data["heart_rate"];
          spo2 = data["spo2"];
          respiration = data["respiratory_rate"];
          temperature = data["body_temperature"].toDouble();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RiskAnalysisScreen()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Risk'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 12),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Live Vitals',
                              style: AppTextStyles.section),
                          const SizedBox(height: 16),

                          VitalCardExact(
                            title: 'Heart Rate',
                            subtitle: 'Beats per minute',
                            value: heartRate.toString(),
                            unit: 'bpm',
                            range: '60–100 bpm',
                            status: 'Normal',
                            trend: '',
                            color: AppColors.danger,
                            icon: Icons.favorite,
                          ),

                          VitalCardExact(
                            title: 'Blood Oxygen',
                            subtitle: 'SpO₂ saturation',
                            value: spo2.toString(),
                            unit: '%',
                            range: '95–100%',
                            status: 'Normal',
                            trend: '',
                            color: AppColors.primary,
                            icon: Icons.water_drop,
                          ),

                          VitalCardExact(
                            title: 'Respiration Rate',
                            subtitle: 'Breaths per minute',
                            value: respiration.toString(),
                            unit: 'rpm',
                            range: '12–20 rpm',
                            status: 'Normal',
                            trend: '',
                            color: AppColors.success,
                            icon: Icons.air,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.monitor_heart, color: AppColors.card),
          const SizedBox(width: 10),
          Text(
            'Cardiopulmonary Monitor',
            style:
                AppTextStyles.section.copyWith(color: AppColors.card),
          ),
        ],
      ),
    );
  }
}

/* ================= VITAL CARD ================= */

class VitalCardExact extends StatelessWidget {
  final String title, subtitle, value, unit, range, status, trend;
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
            const SizedBox(height: 12),
            Text("$value $unit",
                style:
                    AppTextStyles.vitals.copyWith(color: color)),
            const SizedBox(height: 6),
            Text("Range: $range",
                style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
