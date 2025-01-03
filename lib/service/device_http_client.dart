import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:robotic_dashboard/model/device_info.dart';

class DeviceHttpClient {
  final String _baseUrl = dotenv.env['BASE_URL'] ??
      const String.fromEnvironment("BASE_URL",
          defaultValue: "192.168.27.1:8080");
  static const Map<String, String> _headers = {
    'Authorization': 'Bearer robotics',
    'Content-Type': 'application/json',
  };

  Future<void> shutdownDevice() async {
    await http.get(
      Uri.parse('http://$_baseUrl/api/v1/device/shutdown'),
      headers: _headers,
    );
  }

  Future<void> restartDevice() async {
    await http.get(
      Uri.parse('http://$_baseUrl/api/v1/device/restart'),
      headers: _headers,
    );
  }

  Future<Device> getDeviceInfo() async {
    final response = await http.get(
      Uri.parse('http://$_baseUrl/api/v1/device/info'),
      headers: {
        'Authorization': 'Bearer robotics',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        // Parse the JSON and create a Device object
        final device = Device.fromJson(json.decode(response.body));
        return device;
      } catch (e) {
        throw Exception('Failed to parse device information: $e');
      }
    } else {
      throw Exception(
          'Failed to load device information. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateDevice() async {
    final response = await http.post(
      Uri.parse('http://$_baseUrl/api/v1/supervisor/update'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else if (response.statusCode == 409) {
      throw Exception(
          'Request dropped. Another update process is already running.');
    } else {
      throw Exception(
          'Failed to update device. Status code: ${response.statusCode}');
    }
  }
}
