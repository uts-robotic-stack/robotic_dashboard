import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:robotic_dashboard/model/docker/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceHttpClient {
  final String _baseUrl = dotenv.env['BASE_URL'] ??
      const String.fromEnvironment("BASE_URL",
          defaultValue: "192.168.27.1:8080");
  static const Map<String, String> _headers = {
    'Authorization': 'Bearer robotics',
    'Content-Type': 'application/json',
  };

  Future<Map<String, Service>> fetchDefaultServices() async {
    final response = await http.get(
      Uri.parse('http://$_baseUrl/api/v1/supervisor/default'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final servicesMap = jsonResponse['services'] as Map<String, dynamic>;
      final services = <String, Service>{};

      for (var entry in servicesMap.entries) {
        final service = Service.fromJson(entry.value as Map<String, dynamic>);
        service.status = "off";
        services[entry.key] = service;
      }
      return services;
    } else {
      throw Exception('Failed to load default services');
    }
  }

  Future<List<String>> fetchExcludedServices() async {
    final response = await http.get(
      Uri.parse('http://$_baseUrl/api/v1/supervisor/excluded'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).cast<String>();
    } else {
      throw Exception('Failed to load excluded services');
    }
  }

  Future<Map<String, Service>> fetchCurrentServices() async {
    final response = await http.get(
      Uri.parse('http://$_baseUrl/api/v1/supervisor/all'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final servicesMap = jsonResponse['services'] as Map<String, dynamic>;
      final services = <String, Service>{};

      for (var entry in servicesMap.entries) {
        services[entry.key] =
            Service.fromJson(entry.value as Map<String, dynamic>);
      }
      return services;
    } else {
      throw Exception('Failed to load current services');
    }
  }

  Future<void> loadAndRunService(Service service) async {
    final response = await http.post(
      Uri.parse('http://$_baseUrl/api/v1/supervisor/load-run'),
      headers: _headers,
      body: json.encode({
        'services': {service.name: service.toJson()}
      }),
    );
    if (response.statusCode != 200) {
      // Decode the response body to extract the error message
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String errorMessage = responseBody['error'] ??
          'Unknown error'; // Default message if 'error' key is not found
      throw Exception(errorMessage);
    }
  }

  Future<void> stopAndUnloadService(Service service) async {
    final response = await http.post(
      Uri.parse('http://$_baseUrl/api/v1/supervisor/stop-unload'),
      headers: _headers,
      body: json.encode({
        'services': {service.name: ""}
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to stop and unload service');
    }
  }

  Future<void> resetService(Service service) async {
    await stopAndUnloadService(service);
    await loadAndRunService(service);
  }
}
