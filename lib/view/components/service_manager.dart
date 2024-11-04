import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/service_http_client.dart';
import 'package:robotic_dashboard/service/service_log_ws_client.dart';
import 'package:robotic_dashboard/view/widgets/adaptive_switch.dart';
import 'package:robotic_dashboard/view/widgets/pdf_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:robotic_dashboard/responsive/responsive.dart';
import 'dart:convert';
import 'dart:async';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/model/docker/service.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';

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

  String _logOfService = "robotic_supervisor";
  String get logOfService => _logOfService;

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

  Future<void> _loadAndRunService(Service service) async {
    try {
      await _clientProvider.loadAndRunService(service);
      setState(() {
        // Update UI if necessary
      });
    } catch (error) {
      // Handle errors here
    }
  }

  Future<void> _stopAndUnloadService(Service service) async {
    try {
      await _clientProvider.stopAndUnloadService(service);
      setState(() {
        _services[service.name]?.status = "off";
      });
    } catch (error) {
      // Handle errors here
    }
  }

  Future<void> _resetService(Service service) async {
    try {
      await _clientProvider.resetService(service);
      setState(() {
        // Update service status if necessary
      });
    } catch (error) {
      // Handle errors here
    }
  }

  void _startPeriodicFetch() {
    _timer =
        Timer.periodic(_refreshDuration, (Timer t) => _fetchCurrentServices());
  }

  void _showSupervisorSettings(Service service) {
    if (!isAdmin) {
      return;
    }
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
                          'Information',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'FAQ',
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
                        _buildInformationTab(),
                        _buildFAQTab(),
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
        return _buildServiceItem(context, service);
      },
    );
  }

  Widget _buildSettingsTab(
      Map<String, TextEditingController> envVarControllers, Service service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (isAdmin)
              ..._buildAdminSettings(envVarControllers)
            else
              ..._buildUserSettings(service),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdminSettings(
      Map<String, TextEditingController> envVarControllers) {
    return [
      const SizedBox(height: 16.0),
      const Text(
        'Summary',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 16.0),
      const Row(children: [
        Expanded(
          flex: 1,
          child: Text(
            'Name',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 135, 135, 135),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'dobot_controller',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        )
      ]),

      const SizedBox(height: 16.0),
      const Row(children: [
        Expanded(
          flex: 1,
          child: Text(
            'Status',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 135, 135, 135),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'Running',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        )
      ]),

      const SizedBox(height: 16.0),
      const Row(children: [
        Expanded(
          flex: 1,
          child: Text(
            'Software version',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 135, 135, 135),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'a24becd6',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        )
      ]),
      const SizedBox(height: 16.0),
      const Divider(), // Horizontal line // Add spacing between envVars and static texts
      const SizedBox(height: 16.0),
      const Text(
        'Settings',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8.0),
      ...envVarControllers.entries
          .map((entry) => Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(entry.key,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: entry.value,
                        showCursor: true,
                      ),
                    ),
                  ),
                ],
              ))
          .toList(),
      const SizedBox(height: 8.0),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'AUTO-UPDATE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: AdaptiveSwitch(
            follow: true,
            scale: 0.8,
            onChanged: (value) {},
          ),
        )
      ]),
    ];
  }

  List<Widget> _buildUserSettings(Service service) {
    return service.envVars!.entries
        .map((entry) => Column(
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
            ))
        .toList();
  }

  Widget _buildInformationTab() {
    return const PDFDownloadListWidget();
  }

  Widget _buildFAQTab() {
    return Container();
  }

  Widget _buildCommandKeys(BuildContext context, Service data) {
    double padding = 4.0;
    double size = 22.0;

    if (Responsive.isDesktop(context)) {
      padding = 0.0;
      size = 20.0;
    }

    final logsProvider = Provider.of<ServiceLogsWSClient>(context);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              if (data.name == "robotic_supervisor") {
                return;
              }
              _loadAndRunService(data);
            },
            icon: Icon(Icons.play_arrow, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              if (data.name == "robotic_supervisor") {
                return;
              }
              _stopAndUnloadService(data);
            },
            icon: Icon(Icons.stop, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              if (data.name == "robotic_supervisor") {
                return;
              }
              if (data.status != "off") _resetService(data);
            },
            icon: Icon(Icons.settings_backup_restore, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              _logOfService = data.name;

              // Start WS
              if (data.status != "off") {
                logsProvider.disconnectWebSocket();
                logsProvider.logs.clear();
                logsProvider.updateServiceName(data.name);
              }
            },
            icon: Icon(Icons.my_library_books_outlined, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
              if (data.name == "robotic_supervisor") {
                // Show settings specifically to the supervisor (on admin has access)
                _showSupervisorSettings(data);
                return;
              }
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
      width: 175,
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

  Widget _buildServiceItem(BuildContext context, Service data) {
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
                  _buildCommandKeys(context, data),
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
