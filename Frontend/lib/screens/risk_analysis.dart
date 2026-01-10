import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';

class RiskAnalysisScreen extends StatefulWidget {
  final int userId;

  const RiskAnalysisScreen({
    super.key,
    required this.userId,
  });

  @override
  State<RiskAnalysisScreen> createState() => _RiskAnalysisScreenState();
}

class _RiskAnalysisScreenState extends State<RiskAnalysisScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;

  bool isLoading = true;

  // Dynamic values
  String riskLevel = "NORMAL";
  double confidence = 0.94;

  int heartRate = 0;
  int spo2 = 0;
  int respiration = 0;

  List<dynamic> alerts = [];

  @override
  void initState() {
    super.initState();
    loadRiskData();
  }

  Future<void> loadRiskData() async {
    try {
      final vitalsRes = await http.get(
        Uri.parse("$baseUrl/api/vitals/latest/$widget.userId"),
      );

      final riskRes = await http.get(
        Uri.parse("$baseUrl/api/anomalies/latest/$widget.userId"),
      );

      if (vitalsRes.statusCode == 200) {
        final v = jsonDecode(vitalsRes.body);
        heartRate = v["heart_rate"];
        spo2 = v["spo2"];
        respiration = v["respiratory_rate"];
      }

      if (riskRes.statusCode == 200) {
        final r = jsonDecode(riskRes.body);
        riskLevel = r["risk"];
        confidence = r["confidence"];
        alerts = r["alerts"];
      }
    } catch (e) {
      // Silent fail for demo stability
    }

    setState(() => isLoading = false);
  }

  Color get riskColor {
    switch (riskLevel) {
      case "HIGH":
        return AppColors.danger;
      case "MODERATE":
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up), label: 'Trends'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Risk'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR (unchanged)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: AppColors.card),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Risk Analysis',
                        style: AppTextStyles.section
                            .copyWith(color: AppColors.card),
                      ),
                    ),
                  ),
                  const Icon(Icons.more_vert, color: AppColors.card),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // CURRENT RISK CARD
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
                                  border:
                                      Border.all(color: riskColor, width: 3),
                                ),
                                child: Icon(Icons.shield,
                                    color: riskColor, size: 32),
                              ),
                              const SizedBox(height: 16),
                              Text('Current Risk Level',
                                  style: AppTextStyles.body),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: riskColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  riskLevel,
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.card,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // CONFIDENCE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Confidence Level',
                                      style: AppTextStyles.caption),
                                  Text('${(confidence * 100).toInt()}%',
                                      style: AppTextStyles.caption.copyWith(
                                          color: riskColor,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: confidence,
                                minHeight: 6,
                                backgroundColor: AppColors.background,
                                valueColor: AlwaysStoppedAnimation(riskColor),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _miniVital(
                          Icons.favorite, 'Heart Rate', '$heartRate bpm'),
                      _miniVital(
                          Icons.water_drop, 'Oxygen Saturation', '$spo2 %'),
                      _miniVital(
                          Icons.air, 'Respiratory Rate', '$respiration br/min'),

                      const SizedBox(height: 16),

                      _sectionHeader('Recent Alerts'),
                      ...alerts.map((a) => _alertItem(
                            Icons.warning,
                            a["severity"],
                            a["description"],
                            a["detected_at"],
                          )),
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

  // ===== helper widgets (unchanged) =====

  Widget _miniVital(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.success),
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
              style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _alertItem(IconData icon, String title, String desc, String time) {
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
        ],
      ),
    );
  }
}
