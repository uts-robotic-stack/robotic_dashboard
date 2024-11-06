import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceHttpClient {
  static const String _baseUrl = 'http://192.168.27.1:8080/api/v1';
  static const Map<String, String> _headers = {
    'Authorization': 'Bearer robotics',
    'Content-Type': 'application/json',
  };

  Future<void> shutdownDevice() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/device/shutdown'),
      headers: _headers,
    );
  }

  Future<void> restartDevice() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/device/restart'),
      headers: _headers,
    );
  }
}
