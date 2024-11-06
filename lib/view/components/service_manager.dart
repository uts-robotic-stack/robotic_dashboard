import 'package:flutter/material.dart';
import 'package:robotic_dashboard/service/service_http_client.dart';
import 'dart:async';
import 'package:robotic_dashboard/model/docker/service.dart';
import 'package:robotic_dashboard/view/widgets/service_item.dart';

class ServiceManager extends StatefulWidget {
  const ServiceManager({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceManagerState createState() => _ServiceManagerState();
}

class _ServiceManagerState extends State<ServiceManager> {
  final bool isAdmin = true; // Set this based on user role
  bool _fetchDefault = false;
  final Map<String, Service> _services = {};
  final List<String> _excludedServices = [];

  Timer? _currentServiceTimer;
  Timer? _excludedTimer;
  final Duration _currentServiceRefreshDur = const Duration(seconds: 5);
  final Duration _excludedServiceRefreshDur = const Duration(seconds: 5);
  final ServiceHttpClient _clientProvider = ServiceHttpClient();

  @override
  void initState() {
    super.initState();
    _fetchDefaultServices();
    _startPeriodicFetch();
    _startPeriodExcludedServiceFetch();
  }

  @override
  void dispose() {
    _currentServiceTimer?.cancel();
    _excludedTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDefaultServices() async {
    try {
      final services = await _clientProvider.fetchDefaultServices();
      setState(() {
        _services.clear();
        _services.addAll(services);
        _fetchDefault = true;
      });
    } catch (error) {
      // Handle errors here
      _fetchDefault = false;
    }
  }

  Future<void> _fetchExcludedServices() async {
    try {
      final services = await _clientProvider.fetchExcludedServices();
      setState(() {
        _excludedServices.clear();
        _excludedServices.addAll(services);
      });
    } catch (error) {
      // Handle errors here
    }
  }

  Future<void> _fetchCurrentServices() async {
    try {
      final services = await _clientProvider.fetchCurrentServices();
      setState(() {
        for (var entry in services.entries) {
          if (!_excludedServices.contains(entry.key)) {
            _services[entry.key]?.status = entry.value.status;
            if (!_services.containsKey(entry.key)) {
              _services[entry.key] = entry.value;
            }
          }
        }
      });
    } catch (error) {
      // Handle errors here
    }
  }

  void _startPeriodicFetch() {
    _currentServiceTimer = Timer.periodic(_currentServiceRefreshDur, (Timer t) {
      if (!_fetchDefault) {
        _fetchCurrentServices();
      }
      _fetchCurrentServices();
    });
  }

  void _startPeriodExcludedServiceFetch() {
    _excludedTimer = Timer.periodic(
        _excludedServiceRefreshDur, (Timer t) => _fetchExcludedServices());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        // Convert map entries to a list for indexed access
        final entry = _services.entries.elementAt(index);
        final service = entry.value;
        return ServiceItem(
          data: service,
          client: _clientProvider,
        );
      },
    );
  }
}
