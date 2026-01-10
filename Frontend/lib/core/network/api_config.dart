import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? "http://10.1.11.90:3000";

  static String users(int id) => "$baseUrl/api/users/$id";
  static String devices(int id) => "$baseUrl/api/devices/$id";
  static String vitals(int id) => "$baseUrl/api/vitals/$id";
  static String anomalies(int id) => "$baseUrl/api/anomalies/$id";
}
