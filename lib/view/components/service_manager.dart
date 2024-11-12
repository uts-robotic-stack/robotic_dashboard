import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/service_http_client.dart';
import 'dart:async';
import 'package:robotic_dashboard/model/docker/service.dart';
import 'package:robotic_dashboard/service/user_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/utils/warning_dialog.dart';
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

  bool _defaultShowAllServices = false;

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
          if (_defaultShowAllServices) {
            _services[entry.key] = entry.value;
          } else {
            if (!_excludedServices.contains(entry.key)) {
              _services[entry.key] = entry.value;
            } else {
              _services.remove(entry.key);
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
    final userProvider = Provider.of<UserProvider>(context);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: Text(
            "Services",
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Row(
            children: [],
          ),
        ),
        SizedBox(
          width: 117,
          child: Row(
            children: [
              const Text(
                "Show all",
                style: TextStyle(fontSize: 13.0),
              ),
              Transform.scale(
                scale: 0.75, // Use the scale from widget's parameter
                child: Switch.adaptive(
                  activeColor: const Color.fromARGB(255, 21, 167, 77),
                  activeTrackColor: const Color.fromARGB(255, 25, 159, 87),
                  inactiveTrackColor: const Color.fromARGB(255, 171, 171, 171),
                  value: _defaultShowAllServices,
                  onChanged: (value) {
                    if (!userProvider.isSignedIn) {
                      showNotSignInWarning(context);
                      setState(() {
                        _defaultShowAllServices =
                            _defaultShowAllServices; // Reset to original state
                      });
                      return;
                    }
                    if (!userProvider.isAdmin) {
                      showNotAdminWarning(context);
                      // Revert the switch state by resetting _showAllServices
                      setState(() {
                        _defaultShowAllServices =
                            _defaultShowAllServices; // Reset to original state
                      });
                      return;
                    }

                    setState(() {
                      _defaultShowAllServices = value;
                      _fetchCurrentServices();
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ]),
      const Padding(
        padding: EdgeInsets.only(top: 6.0),
        child: Divider(),
      ),
      Expanded(
          child: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final entry = _services.entries.elementAt(index);
          final service = entry.value;
          return ServiceItem(
            data: service,
            client: _clientProvider,
          );
        },
      ))
    ]);
  }
}
