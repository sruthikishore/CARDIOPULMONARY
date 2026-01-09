import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_textstyles.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  final int userId = 1;

  bool isLoading = true;

  String name = "";
  String email = "";
  List<dynamic> devices = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final userRes =
          await http.get(Uri.parse("$baseUrl/api/users/$userId"));
      final deviceRes =
          await http.get(Uri.parse("$baseUrl/api/devices/$userId"));

      if (userRes.statusCode == 200) {
        final u = jsonDecode(userRes.body);
        name = u["name"];
        email = u["email"];
      }

      if (deviceRes.statusCode == 200) {
        devices = jsonDecode(deviceRes.body);
      }
    } catch (_) {
      // silent fail for demo stability
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: const Icon(Icons.arrow_back),
        title: const Text('Profile & Settings'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= PROFILE CARD =================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: AppTextStyles.section),
                            const SizedBox(height: 4),
                            Text(email, style: AppTextStyles.caption),
                            const SizedBox(height: 4),
                            Text(
                              'Patient ID: #CM-$userId',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
              ),

              const SizedBox(height: 24),

              // ================= DEVICE CONNECTION =================
              Text('Device Connection', style: AppTextStyles.section),
              const SizedBox(height: 12),

              ...devices.map(
                (d) => _deviceTile(
                  icon: _iconForDevice(d["device_type"]),
                  title: d["device_type"],
                  subtitle:
                      d["connected"] ? "Connected" : "Not Connected",
                  connected: d["connected"],
                ),
              ),

              const SizedBox(height: 24),

              // ================= NOTIFICATIONS =================
              Text('Notification Preferences',
                  style: AppTextStyles.section),
              const SizedBox(height: 12),

              _switchTile(
                icon: Icons.notifications_active,
                title: 'Critical Alerts',
                subtitle: 'Immediate health warnings',
                value: true,
              ),
              _switchTile(
                icon: Icons.warning,
                title: 'Warning Alerts',
                subtitle: 'Moderate health concerns',
                value: true,
              ),
              _switchTile(
                icon: Icons.bar_chart,
                title: 'Daily Reports',
                subtitle: 'Daily health summary',
                value: true,
              ),
              _switchTile(
                icon: Icons.email,
                title: 'Email Updates',
                subtitle: 'Weekly health insights',
                value: false,
              ),

              const SizedBox(height: 24),

              // ================= APPEARANCE =================
              Text('Appearance', style: AppTextStyles.section),
              const SizedBox(height: 12),

              _switchTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: false,
              ),

              const SizedBox(height: 24),

              // ================= SETTINGS =================
              Text('Settings', style: AppTextStyles.section),
              const SizedBox(height: 12),

              _arrowTile(Icons.lock, 'Privacy & Security'),
              _arrowTile(Icons.folder, 'Medical History'),
              _arrowTile(Icons.local_hospital, 'Healthcare Provider'),
              _arrowTile(Icons.help, 'Help & Support'),
              _arrowTile(Icons.info, 'About App'),

              const SizedBox(height: 32),

              // ================= LOGOUT =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout,
                      color: AppColors.danger),
                  label: Text(
                    'Logout',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Version 2.1.4',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  IconData _iconForDevice(String type) {
    if (type.contains("Heart")) return Icons.favorite;
    if (type.contains("Lung")) return Icons.air;
    return Icons.watch;
  }

  Widget _deviceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool connected,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              connected ? AppColors.success : AppColors.textSecondary,
        ),
        title: Text(title, style: AppTextStyles.body),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: connected
            ? const Icon(Icons.check_circle,
                color: AppColors.success)
            : Text(
                'Connect',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.body),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: Switch(value: value, onChanged: (_) {}),
      ),
    );
  }

  Widget _arrowTile(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.body),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
