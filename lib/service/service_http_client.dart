import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:robotic_dashboard/model/docker/service.dart';

class ServiceHttpClient {
  static const String _baseUrl = 'http://localhost:8080/api/v1/supervisor';
  static const Map<String, String> _headers = {
    'Authorization': 'Bearer robotics',
    'Content-Type': 'application/json',
  };

  Future<Map<String, Service>> fetchDefaultServices() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/default'),
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
      Uri.parse('$_baseUrl/excluded'),
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
      Uri.parse('$_baseUrl/all'),
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
      Uri.parse('$_baseUrl/load-run'),
      headers: _headers,
      body: json.encode({
        'services': {service.name: service.toJson()}
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load and run service');
    }
  }

  Future<void> stopAndUnloadService(Service service) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/stop-unload'),
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
