import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/responsive/responsive.dart';
import 'package:robotic_dashboard/service/device_http_client.dart';
import 'package:robotic_dashboard/service/device_provider.dart';
import 'package:robotic_dashboard/service/user_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/view/widgets/warning_dialog.dart';
import 'package:robotic_dashboard/view/components/device_info.dart';
import 'package:robotic_dashboard/view/components/header.dart';
import 'package:robotic_dashboard/view/components/log_viewer.dart';
import 'package:robotic_dashboard/view/components/service_manager.dart';
import 'package:robotic_dashboard/view/screens/side_menu.dart';
// import 'package:robotic_dashboard/view/widgets/dropdown_button.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (Responsive.isDesktop(context))
          const SizedBox(width: defaultSideMenuWidth, child: SideMenu()),
        const Expanded(
          flex: 1,
          child: Column(
            children: [
              Header(
                headerText: 'DASHBOARD',
              ),
              DeviceInfo(),
              ControllerDashboard(),
              SizedBox(
                height: defaultPadding,
              ),
            ],
          ),
        ),
        if (Responsive.isDesktop(context))
          Expanded(flex: 1, child: LogsViewer())
      ],
    ));
  }
}

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  final DeviceHttpClient _deviceHttpClient = DeviceHttpClient();
  Color _statusColor = const Color.fromARGB(255, 47, 129, 83);
  bool _showUpdateBar = false;
  // Icon _statusIcon = Icon(Iconp)

  Future<void> _showRestartWarning(BuildContext context) async {
    bool shouldRestart = await showRestartWarningDialog(context);
    if (shouldRestart) {
      _statusColor = Colors.red;
      setState(() {});
      _deviceHttpClient.restartDevice();
    }
  }

  Future<void> _showShutdownWarning(BuildContext context) async {
    bool shouldShutdown = await showShutdownWarningDialog(context);
    if (shouldShutdown) {
      _statusColor = Colors.red;
      setState(() {});
      _deviceHttpClient.shutdownDevice();
    }
  }

  Future<void> _showUpdateWarning(BuildContext context) async {
    bool shouldUpdate = await showUpdateWarningDialog(context);
    if (shouldUpdate) {
      _statusColor = Colors.blue;
      // setState(() {});
      // _deviceHttpClient.shutdownDevice();
      _showUpdateBar = true;
      setState(() {});
      await Future.delayed(const Duration(seconds: 10));
      _showUpdateBar = false;
      _statusColor = const Color.fromARGB(255, 47, 129, 83);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = Provider.of<DeviceProvider>(context).device;
    final userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: SizedBox(
        height: 315,
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: borderColor)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check_circle_outline,
                              color: _statusColor, size: 20),
                        ),
                      ],
                    ),
                  ),
                  if (_showUpdateBar)
                    Expanded(
                      child: // Show progress bar if restarting
                          Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text("Updating device...",
                                style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 2),
                            LinearProgressIndicator(
                              minHeight: 3,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                              onPressed: () {
                                if (!userProvider.isSignedIn) {
                                  showNotSignInWarning(context);
                                  return;
                                }
                                if (!userProvider.isAdmin) {
                                  showNotAdminWarning(context);
                                  return;
                                }
                                _showUpdateWarning(context);
                              },
                              icon: const Icon(
                                Icons.download,
                                size: 20,
                                color: Colors.black,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                              onPressed: () {
                                if (!userProvider.isSignedIn) {
                                  showNotSignInWarning(context);
                                  return;
                                }
                                _showRestartWarning(context);
                              },
                              icon: const Icon(
                                Icons.restart_alt,
                                size: 20,
                                color: Colors.black,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                              onPressed: () {
                                if (!userProvider.isSignedIn) {
                                  showNotSignInWarning(context);
                                  return;
                                }
                                _showShutdownWarning(context);
                              },
                              icon: const Icon(
                                Icons.power_settings_new,
                                size: 20,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Divider(),
              ),
              const SizedBox(height: 8.0),
              Expanded(child: DeviceInfoList())
            ]),
          ),
        ),
      ),
    );
  }
}

class ControllerDashboard extends StatelessWidget {
  const ControllerDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: borderColor)),
            child: const ServiceManager()),
      ),
    );
  }
}
