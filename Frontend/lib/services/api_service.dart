import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/network/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>?> getUser(int userId) async {
    final res = await http.get(Uri.parse(ApiConfig.users(userId)));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getVitals(int userId) async {
    final res = await http.get(Uri.parse(ApiConfig.vitals(userId)));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }

  static Future<List<dynamic>> getAnomalies(int userId) async {
    final res = await http.get(Uri.parse(ApiConfig.anomalies(userId)));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }
}
