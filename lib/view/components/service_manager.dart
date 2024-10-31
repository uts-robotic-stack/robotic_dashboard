import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robotics_dashboard/view/widgets/pdf_downloader.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'package:robotics_dashboard/responsive/responsive.dart';
import 'dart:convert';
import 'dart:async';
import 'package:robotics_dashboard/utils/constants.dart';
import 'package:robotics_dashboard/model/docker/service.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart'; // You can use other themes

class ServiceManager extends StatefulWidget {
  const ServiceManager({Key? key}) : super(key: key);

  @override
  _ServiceManagerState createState() => _ServiceManagerState();
}

class _ServiceManagerState extends State<ServiceManager> {
  final bool isAdmin = true; // Set this based on user role
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
        services[entry.key]?.status = "off";
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
          if (!_excludedServices.contains(entry.key)) {
            _services[entry.key]?.status = entry.value.status;
          }
        }
      });
    } else {}
  }

  // Function to send HTTP request containing the current service information
  Future<void> _loadAndRunService(Service service) async {
    const String endpointUrl =
        'http://localhost:8080/api/v1/supervisor/load-run'; // Replace with your actual endpoint

    final Map<String, dynamic> serviceMap = {
      'services': {
        service.name: service.toJson(),
      },
    };

    try {
      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(serviceMap),
      );
      if (response.statusCode == 200) {
        // print('Service info successfully sent for ${service.name}');
        setState(() {
          // _services[service.name]?.status = "running";
        });
      } else {
        // print('Failed to send service info: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error sending service info: $error');
    }
  }

  // Function to send HTTP request containing the current service information
  Future<void> _stopAndUnloadService(Service service) async {
    const String endpointUrl =
        'http://localhost:8080/api/v1/supervisor/stop-unload'; // Replace with your actual endpoint

    final Map<String, dynamic> serviceMap = {
      'services': {
        service.name: "",
      },
    };

    try {
      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(serviceMap),
      );

      if (response.statusCode == 200) {
        // print('Service info successfully sent for ${service.name}');
        setState(() {
          _services[service.name]?.status = "off";
        });
      } else {
        // print('Failed to send service info: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error sending service info: $error');
    }
  }

  // Function to send HTTP request containing the current service information
  Future<void> _resetService(Service service) async {
    const String stopUnloadUrl =
        'http://localhost:8080/api/v1/supervisor/stop-unload'; // Replace with your actual endpoint

    final Map<String, dynamic> serviceMap = {
      'services': {
        service.name: "",
      },
    };

    try {
      final response = await http.post(
        Uri.parse(stopUnloadUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(serviceMap),
      );

      if (response.statusCode == 200) {
        // print('Service info successfully sent for ${service.name}');
        const String loadStartUrl =
            'http://localhost:8080/api/v1/supervisor/load-run'; // Replace with your actual endpoint

        final Map<String, dynamic> serviceMap = {
          'services': {
            service.name: service.toJson(),
          },
        };

        try {
          final response = await http.post(
            Uri.parse(loadStartUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(serviceMap),
          );
          if (response.statusCode == 200) {
            // print('Service info successfully sent for ${service.name}');
            setState(() {
              // _services[service.name]?.status = "running";
            });
          } else {
            // print('Failed to send service info: ${response.statusCode}');
          }
        } catch (error) {
          // print('Error sending service info: $error');
        }
      } else {
        // print('Failed to send service info: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error sending service info: $error');
    }
  }

  void _startPeriodicFetch() {
    _timer =
        Timer.periodic(_refreshDuration, (Timer t) => _fetchCurrentServices());
  }

  void _showServiceSettings(Service service) {
    final Map<String, TextEditingController> envVarControllers = {
      for (var entry
          in service.envVars?.entries ?? <MapEntry<String, String>>[])
        entry.key: TextEditingController(text: entry.value),
    };
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${service.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 900,
            height: 500,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'FAQ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Information',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildSettingsTab(envVarControllers, service),
                        _buildExampleTab(),
                        _buildInformationTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            if (isAdmin)
              TextButton(
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  setState(() {
                    service.envVars = {
                      for (var entry in envVarControllers.entries)
                        entry.key: entry.value.text,
                    };
                  });
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16.0),
              ),
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

  Widget _buildSettingsTab(
      Map<String, TextEditingController> envVarControllers, Service service) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          if (isAdmin)
            ...envVarControllers.entries.map((entry) => Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('${entry.key}:',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: entry.value,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          else
            ...service.envVars!.entries.map((entry) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('${entry.key}:',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SelectableText(
                              entry.value,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    )
                  ],
                )),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    return PDFDownloadListWidget();
  }

  Widget _buildExampleTab() {
    return Center(
      child: HighlightView(
        '''
def greet(name):
    print(f"Hello, {name}!")

greet("World")
            ''',
        language: 'python',
        theme: atomOneLightTheme,
        padding: EdgeInsets.all(12),
        textStyle: TextStyle(fontFamily: 'Courier', fontSize: 16),
      ),
    );
  }

  Widget _buildCommandKeys(Service data) {
    double padding = 4.0;
    double size = 22.0;

    if (Responsive.isDesktop(context)) {
      padding = 0.0;
      size = 20.0;
    }
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              _loadAndRunService(data);
            },
            icon: Icon(Icons.play_arrow, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              _stopAndUnloadService(data);
            },
            icon: Icon(Icons.stop, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              if (data.status != "off") _resetService(data);
            },
            icon: Icon(Icons.settings_backup_restore, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.my_library_books_outlined, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              _showServiceSettings(data);
            },
            icon: Icon(Icons.settings, size: size),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(Service data) {
    BoxDecoration decoration = const BoxDecoration(
      color: Color.fromARGB(255, 255, 75, 75),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );
    switch (data.status) {
      case "off":
        decoration = const BoxDecoration(
          color: Color.fromARGB(255, 255, 75, 75),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        );
      case "running":
        decoration = const BoxDecoration(
          color: Color.fromARGB(255, 34, 157, 67),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        );
      case "updating":
        decoration = const BoxDecoration(
          color: Color.fromARGB(255, 0, 91, 166),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        );
      case "starting":
        decoration = const BoxDecoration(
          color: Color.fromARGB(255, 191, 176, 42),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        );
    }

    String status = data.status ?? 'off';
    return Container(
      width: 110,
      height: 25,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Center(
        child: Text(
          status,
          style: const TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildServiceName(Service data) {
    return SizedBox(
      width: 200,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: defaultPadding),
        child: Text(
          data.name,
          style: const TextStyle(color: Colors.black, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildServiceItem(Service data) {
    return Column(
      children: [
        Container(
          height: 75,
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
                  _buildServiceName(data),
                  _buildStatusBar(data),
                  _buildCommandKeys(data),
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
