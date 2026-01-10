import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';
import 'risk_analysis.dart';

import 'profile.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;

  const DashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

int _currentIndex = 0;

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  bool hasError = false;

  int heartRate = 0;
  int spo2 = 0;
  int respiratoryRate = 0;
  double bodyTemperature = 0.0;

  late final String baseUrl;

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL']!;
    fetchLatestVitals();
  }

  Future<void> fetchLatestVitals() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/vitals/${widget.userId}"),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          heartRate = data["heart_rate"] ?? 0;
          spo2 = data["spo2"] ?? 0;
          respiratoryRate = data["respiratory_rate"] ?? 0;
          bodyTemperature = (data["body_temperature"] ?? 0).toDouble();

          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() => _currentIndex = index);

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RiskAnalysisScreen(userId: widget.userId),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileSettingsScreen(userId: widget.userId),
              ),
            );
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                        ? _errorView()
                        : _vitalsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Image.asset(
          'assets/logo.png',
          width: 44,
          height: 44,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Text(
          'Vitals AI',
          style: AppTextStyles.section.copyWith(
            color: AppColors.card,
          ),
        ),
      ],
    ),
  );
}


  // ================= ERROR VIEW =================
  Widget _errorView() {
    return Center(
      child: Text(
        "Unable to load vitals.\nCheck backend connection.",
        textAlign: TextAlign.center,
        style: AppTextStyles.body,
      ),
    );
  }

  // ================= VITALS VIEW =================
  Widget _vitalsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Live Vitals', style: AppTextStyles.section),
          const SizedBox(height: 16),
          VitalCardExact(
            title: 'Heart Rate',
            subtitle: 'Beats per minute',
            value: heartRate.toString(),
            unit: 'bpm',
            range: '60–100 bpm',
            status: _status(heartRate, 60, 100),
            color: AppColors.danger,
            icon: Icons.favorite,
          ),
          VitalCardExact(
            title: 'Blood Oxygen',
            subtitle: 'SpO₂ saturation',
            value: spo2.toString(),
            unit: '%',
            range: '95–100%',
            status: _status(spo2, 95, 100),
            color: AppColors.primary,
            icon: Icons.water_drop,
          ),
          VitalCardExact(
            title: 'Respiration Rate',
            subtitle: 'Breaths per minute',
            value: respiratoryRate.toString(),
            unit: 'rpm',
            range: '12–20 rpm',
            status: _status(respiratoryRate, 12, 20),
            color: AppColors.success,
            icon: Icons.air,
          ),
          VitalCardExact(
            title: 'Body Temperature',
            subtitle: 'Degrees Celsius',
            value: bodyTemperature.toStringAsFixed(1),
            unit: '°C',
            range: '36.1–37.2 °C',
            status: bodyTemperature > 37.5 ? "High" : "Normal",
            color: AppColors.warning,
            icon: Icons.thermostat,
          ),
        ],
      ),
    );
  }

  String _status(int value, int min, int max) {
    if (value < min) return "Low";
    if (value > max) return "High";
    return "Normal";
  }
}

/* ================= VITAL CARD ================= */

class VitalCardExact extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final String range;
  final String status;
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
            Text(
              "$value $unit",
              style: AppTextStyles.vitals.copyWith(color: color),
            ),
            const SizedBox(height: 6),
            Text(
              "Range: $range · Status: $status",
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
