import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/service_http_client.dart';
import 'package:robotic_dashboard/service/service_log_ws_client.dart';
import 'package:robotic_dashboard/view/widgets/adaptive_switch.dart';
import 'package:robotic_dashboard/view/widgets/pdf_downloader.dart';
import 'package:robotic_dashboard/responsive/responsive.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/model/docker/service.dart';

// ignore: must_be_immutable
class ServiceItem extends StatefulWidget {
  Service data;
  ServiceHttpClient client;
  ServiceItem({super.key, required this.data, required this.client});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  final bool isAdmin = true;
  bool _defaultAutoUpdate = true;
  bool _defaultAutoRestart = true;

  Future<void> _loadAndRunService(Service service) async {
    try {
      await widget.client.loadAndRunService(service);
      bool pendingAlertClosed = false;
      // Ensure the widget is still mounted before proceeding
      if (mounted) {
        // Show the loading dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog manually
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Starting service',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
              content: const SizedBox(
                width: 300,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Service is starting... Please wait."),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    pendingAlertClosed = true;
                  },
                ),
              ],
            );
          },
        );

        // Poll the service status until it's no longer "off"
        while (service.status == "off") {
          await Future.delayed(
              const Duration(milliseconds: 100)); // Poll every 2 seconds
        }

        // Close the loading dialog once the service status is no longer "off"
        if (mounted && !pendingAlertClosed) {
          Navigator.of(context).pop(); // Close the pending dialog
        }
      }
      // Optionally, show a success message or update the UI
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Ensure the widget is still mounted before showing the dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              width: 400,
              height: 150,
              child: AlertDialog(
                title: const Text(
                  'Error',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                content: SizedBox(
                  width: 400,
                  child: Text(error.toString(),
                      style: const TextStyle(fontSize: 14.0),
                      softWrap: true,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
      // Additional error handling can be done here if needed
    }
  }

  Future<void> _stopAndUnloadService(Service service) async {
    try {
      await widget.client.stopAndUnloadService(service);
      if (mounted) {
        // Show loading dialog for 1 second
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog manually
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text(
                'Stopping service',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              content: SizedBox(
                width: 300,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Service is shutting down... Please wait"),
                  ],
                ),
              ),
            );
          },
        );

        // Close the dialog after 1 second
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop(); // Close the loading dialog
        }
      }

      // Update the status after the dialog is closed
      if (mounted) {
        setState(() {
          widget.data.status = "off";
        });
      }
    } catch (error) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Error',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              content: SizedBox(
                width: 300,
                child: Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 14.0),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _resetService(Service service) async {
    try {
      await widget.client.resetService(service);
      bool pendingAlertClosed = false;
      // Ensure the widget is still mounted before proceeding
      if (mounted) {
        // Show the loading dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog manually
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Starting service',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
              content: const SizedBox(
                width: 300,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Service is restarting... Please wait."),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    pendingAlertClosed = true;
                  },
                ),
              ],
            );
          },
        );

        // Poll the service status until it's no longer "off"
        while (service.status == "off") {
          await Future.delayed(
              const Duration(milliseconds: 100)); // Poll every 2 seconds
        }

        // Close the loading dialog once the service status is no longer "off"
        if (mounted && !pendingAlertClosed) {
          Navigator.of(context).pop(); // Close the pending dialog
        }
      }
      // Optionally, show a success message or update the UI
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Ensure the widget is still mounted before showing the dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              width: 400,
              height: 150,
              child: AlertDialog(
                title: const Text(
                  'Error',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                content: SizedBox(
                  width: 400,
                  child: Text(error.toString(),
                      style: const TextStyle(fontSize: 14.0),
                      softWrap: true,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
      // Additional error handling can be done here if needed
    }
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
              if (data.status == "off") {
                _loadAndRunService(data);
              }
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
              _resetService(data);
            },
            icon: Icon(Icons.settings_backup_restore, size: size),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: IconButton(
            onPressed: () {
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
              _showServiceSettings(data);
            },
            icon: Icon(Icons.settings, size: size),
          ),
        ),
      ],
    );
  }

  void _showServiceSettings(Service service) {
    final Map<String, TextEditingController> envVarControllers = {
      for (var entry
          in service.envVars?.entries ?? <MapEntry<String, String>>[])
        entry.key: TextEditingController(text: entry.value),
    };

    bool settingsChanged = false; // Flag to track if text has changed

    // Store the initial values to compare later
    final Map<String, String> initialValues = {
      for (var entry in envVarControllers.entries) entry.key: entry.value.text,
    };

    // Register listeners for each TextEditingController to detect and compare changes
    envVarControllers.forEach((key, controller) {
      controller.addListener(() {
        final newText = controller.text;
        final oldText = initialValues[key] ?? '';

        // Compare the new text with the initial value
        if (newText != oldText) {
          settingsChanged = true;
        } else {
          // Reset flag if all controllers match their initial values
          settingsChanged = envVarControllers.entries
              .any((entry) => entry.value.text != initialValues[entry.key]);
        }

        // Optionally call setState or update the UI based on hasTextChanged
      });
    });

    TextEditingController commandController =
        TextEditingController(text: service.getCommand());
    final String initialCommand = service.getCommand();
    commandController.addListener(() {
      final newCommand = commandController.text;
      if (newCommand != initialCommand) {
        settingsChanged = true;
      }
    });
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
                        _buildSettingsTab(
                            envVarControllers, commandController, service),
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
            TextButton(
              onPressed: () {
                if (settingsChanged) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Saving Service Settings',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                        content: const SizedBox(
                          width: 300,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  softWrap: true,
                                  maxLines: 5,
                                  style: TextStyle(fontSize: 14.0),
                                  "Service will be restarted for the new settings to be applied. Do you wish to proceed ?"),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              setState(() {
                                service.envVars = {
                                  for (var entry in envVarControllers.entries)
                                    entry.key: entry.value.text,
                                };
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              _resetService(service);
                            },
                          ),
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              // reset text
                              commandController.text = initialCommand;
                              envVarControllers.forEach((key, controller) {
                                controller.text = initialValues[key]!;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 16.0),
              ),
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

  Widget _buildSettingsTab(Map<String, TextEditingController> envVarControllers,
      TextEditingController commandController, Service service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (isAdmin)
              ..._buildAdminSettings(
                  envVarControllers, commandController, widget.data)
            else
              ..._buildUserSettings(service),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdminSettings(
      Map<String, TextEditingController> envVarControllers,
      TextEditingController commandController,
      Service data) {
    return [
      const Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Text(
          'Summary',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
      ServiceSummaryItem(field: "Name", value: data.name),
      const SizedBox(height: 16.0),
      ServiceSummaryItem(field: "Status", value: data.status ?? "off"),
      const SizedBox(height: 16.0),
      ServiceSummaryItem(field: "Software version", value: data.image.id ?? ""),
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
      const SizedBox(height: 4.0),
      Row(children: [
        const Expanded(
          flex: 1,
          child: Text(
            "COMMAND: ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: commandController,
              showCursor: true,
            ),
          ),
        )
      ]),
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
            follow: _defaultAutoUpdate,
            scale: 0.8,
            onChanged: (value) {
              if (!isAdmin) {
                return;
              }
              _defaultAutoUpdate = value;
            },
          ),
        )
      ]),
      const SizedBox(height: 10.0),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'RESTART',
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
            follow: _defaultAutoRestart,
            scale: 0.8,
            onChanged: (value) {
              if (!isAdmin) {
                return;
              }
              _defaultAutoRestart = value;
            },
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

  @override
  Widget build(BuildContext context) {
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
                  _buildServiceName(widget.data),
                  _buildStatusBar(widget.data),
                  _buildCommandKeys(context, widget.data),
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

class ServiceSummaryItem extends StatelessWidget {
  final String field;
  final String value;
  const ServiceSummaryItem(
      {super.key, required this.field, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Text(
          field,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 135, 135, 135),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ),
      )
    ]);
  }
}
