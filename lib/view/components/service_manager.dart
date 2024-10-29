import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:robotics_dashboard/utils/constants.dart';
import 'package:robotics_dashboard/model/docker/service.dart';

class ServiceManager extends StatefulWidget {
  const ServiceManager({Key? key}) : super(key: key);

  @override
  _ServiceManagerState createState() => _ServiceManagerState();
}

class _ServiceManagerState extends State<ServiceManager> {
  final bool isAdmin = false; // Set this based on user role
  final Map<String, Service> _services = {};
  final List<String> _excludedServices = [];

  Timer? _timer;
  final Duration _refreshDuration = const Duration(seconds: 5);

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
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/supervisor/default'),
      headers: {
        'Authorization': 'Bearer robotics',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final Map<String, dynamic> servicesMap = jsonResponse['services'];
      final Map<String, Service> services = {};

      for (var entry in servicesMap.entries) {
        services[entry.key] =
            Service.fromJson(entry.value as Map<String, dynamic>);
      }

      setState(() {
        _services.clear();
        _services.addAll(services);
      });
    } else {
      // print('Failed to load services with status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchExcludedServices() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/supervisor/excluded'),
      headers: {
        'Authorization': 'Bearer robotics',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;

      // Convert the dynamic list to a List<String>
      final List<String> services = jsonResponse.cast<String>();
      setState(() {
        _excludedServices.clear();
        _excludedServices.addAll(services);
      });
    } else {
      // print('Failed to load services with status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchCurrentServices() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/supervisor/all'),
      headers: {
        'Authorization': 'Bearer robotics',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final Map<String, dynamic> servicesMap = jsonResponse['services'];
      final Map<String, Service> services = {};

      for (var entry in servicesMap.entries) {
        services[entry.key] =
            Service.fromJson(entry.value as Map<String, dynamic>);
      }

      setState(() {
        for (var entry in services.entries) {
          if (!_services.containsKey(entry.key) &&
              !_excludedServices.contains(entry.key)) {
            _services[entry.key] = entry.value;
          }
        }
      });
    } else {}
  }

  void _startPeriodicFetch() {
    _timer =
        Timer.periodic(_refreshDuration, (Timer t) => _fetchCurrentServices());
  }

  void _showServiceSettings(Service service) {
    // Editable controllers
    final TextEditingController imageController =
        TextEditingController(text: service.image);
    final TextEditingController actionController =
        TextEditingController(text: service.action);
    final TextEditingController networkController =
        TextEditingController(text: service.network ?? "");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${service.name} settings'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                isAdmin
                    ? TextFormField(
                        controller: imageController,
                        decoration: const InputDecoration(labelText: 'Image'),
                      )
                    : Text('Image: ${service.image}'),
                isAdmin
                    ? TextFormField(
                        controller: actionController,
                        decoration: const InputDecoration(labelText: 'Action'),
                      )
                    : Text('Action: ${service.action}'),
                isAdmin
                    ? TextFormField(
                        controller: networkController,
                        decoration: const InputDecoration(labelText: 'Network'),
                      )
                    : Text('Network: ${service.network ?? "N/A"}'),
                Text('TTY: ${service.tty}'),
                Text('Privileged: ${service.privileged}'),
              ],
            ),
          ),
          actions: <Widget>[
            if (isAdmin)
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() {
                    // Update service settings with edited values
                    // service.image = imageController.text;
                    // service.action = actionController.text;
                    // service.network = networkController.text.isNotEmpty
                    //     ? networkController.text
                    //     : null;
                  });
                  Navigator.of(context).pop();
                  // Add code to save changes to server if needed
                },
              ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        // Convert map entries to a list for indexed access
        final entry = _services.entries.elementAt(index);
        final service = entry.value;
        return _buildServiceItem(service);
      },
    );
  }

  Widget _buildServiceItem(Service data) {
    return Column(
      children: [
        Container(
          height: 150,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color.fromARGB(26, 0, 0, 0)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow, size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.pause, size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.stop, size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.my_library_books_outlined,
                            size: 20.0),
                      ),
                      IconButton(
                        onPressed: () {
                          _showServiceSettings(data);
                        },
                        icon: const Icon(Icons.settings, size: 20.0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
