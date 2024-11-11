import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:robotic_dashboard/model/device_info.dart';
import 'package:http/http.dart' as http;

class DeviceProvider with ChangeNotifier {
  final String _baseUrl = dotenv.env['BASE_URL'] ??
      const String.fromEnvironment("BASE_URL",
          defaultValue: "192.168.27.1:8080");

  Device _device = Device.init();
  Device get device {
    return _device;
  }

  Timer? _updateTimer;

  DeviceProvider() {
    _fetchDeviceData();
    _startDeviceUpdates();
  }

  // Method to start periodic HTTP requests
  void _startDeviceUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fetchDeviceData();
    });
  }

  // Method to fetch device data from the HTTP endpoint
  Future<void> _fetchDeviceData() async {
    try {
      final response = await http.get(
        Uri.parse('http://$_baseUrl/api/v1/device/info'),
        headers: {
          'Authorization': 'Bearer robotics',
          "Content-Type":
              "application/json" // Include your access token or any other headers
        },
      );
      if (response.statusCode == 200) {
        _device = Device.fromJson(json.decode(
            response.body)); // Assuming your Device model has a fromJson method
        notifyListeners();
      } else {
        // Handle non-200 status codes if necessary
        // print('Failed to load device info: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error fetching device info: $error');
    }
  }

  // Cancel timer when no longer needed
  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
