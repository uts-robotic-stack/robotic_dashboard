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
  final Map<String, Service> _services = {};
  final List<String> _excludedServices = [];

  Timer? _timer;
  final Duration _refreshDuration = const Duration(seconds: 1);
  final ServiceHttpClient _clientProvider = ServiceHttpClient();

  @override
  void initState() {
    super.initState();
    _fetchDefaultServices();
    _fetchExcludedServices();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDefaultServices() async {
    try {
      final services = await _clientProvider.fetchDefaultServices();
      setState(() {
        _services.clear();
        _services.addAll(services);
      });
    } catch (error) {
      // Handle errors here
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

  // Future<void> _loadAndRunService(Service service) async {
  //   try {
  //     await _clientProvider.loadAndRunService(service);
  //     setState(() {
  //       // Update UI if necessary
  //     });
  //   } catch (error) {
  //     // Handle errors here
  //   }
  // }

  // Future<void> _stopAndUnloadService(Service service) async {
  //   try {
  //     await _clientProvider.stopAndUnloadService(service);
  //     setState(() {
  //       _services[service.name]?.status = "off";
  //     });
  //   } catch (error) {
  //     // Handle errors here
  //   }
  // }

  // Future<void> _resetService(Service service) async {
  //   try {
  //     await _clientProvider.resetService(service);
  //     setState(() {
  //       // Update service status if necessary
  //     });
  //   } catch (error) {
  //     // Handle errors here
  //   }
  // }

  void _startPeriodicFetch() {
    _timer =
        Timer.periodic(_refreshDuration, (Timer t) => _fetchCurrentServices());
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
