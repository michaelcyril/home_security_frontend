import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.206.193:8000'; // Replace with your Django API base URL

  // Fetch intruder attempts
  static Future<List<dynamic>> fetchIntruderAttempts() async {
    final response = await http.get(Uri.parse('$baseUrl/create-get-intruder-attempt'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load intruder attempts');
    }
  }

  
  // Fetch sensors statuses
  static Future<List<dynamic>> fetchSensorStatuses() async {
    final response = await http.get(Uri.parse('$baseUrl/create-get-sensor'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load sensors statuses');
    }
  }

  // Toggle alarm status
  Future<int> toggleAlarm() async {
    final response = await http.get(Uri.parse('$baseUrl/activate-deactivate-alarm'));
    if (response.statusCode == 200) {
      print("object");
      return json.decode(response.body)['status'];
    } else {
      throw Exception('Failed to toggle alarm status');
    }
  }

   // Get alarm status
  static Future<Map<String, dynamic>> getAlarmStatus() async {
    final response = await http.get(Uri.parse('$baseUrl/create-get-alarm'));
    if (response.statusCode == 200) {
      String responseBody = response.body;
      List<String> statusParts = responseBody.split('*');
      if (statusParts.length == 2) {
        List<String> statusNormalParts = statusParts[1].split('=');
        if (statusNormalParts.length == 2) {
          return {
            'status': int.parse(statusNormalParts[0]),
            'normal_status': int.parse(statusNormalParts[1].split("")[0]),
          };
        }
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to get alarm status');
    }
  }
}
