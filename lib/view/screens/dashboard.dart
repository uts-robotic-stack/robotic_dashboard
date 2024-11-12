import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/responsive/responsive.dart';
import 'package:robotic_dashboard/service/device_http_client.dart';
import 'package:robotic_dashboard/service/device_provider.dart';
import 'package:robotic_dashboard/service/user_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/utils/warning_dialog.dart';
import 'package:robotic_dashboard/view/components/device_info.dart';
import 'package:robotic_dashboard/view/components/header.dart';
import 'package:robotic_dashboard/view/components/log_viewer.dart';
import 'package:robotic_dashboard/view/components/service_manager.dart';
import 'package:robotic_dashboard/view/screens/side_menu.dart';
import 'package:robotic_dashboard/view/widgets/dropdown_button.dart';

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
                  Row(
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
                  CustomHamburgerDropdown(
                    dropdownWidth: 150.0, // Set a custom width for the dropdown
                    items: [
                      DropdownItem(
                        label: 'Update',
                        onChanged: () {
                          if (!userProvider.isSignedIn) {
                            showNotSignInWarning(context);
                            return;
                          }
                        },
                      ),
                      DropdownItem(
                        label: 'Reboot',
                        onChanged: () {
                          if (!userProvider.isSignedIn) {
                            showNotSignInWarning(context);
                            return;
                          }
                          _statusColor = Colors.red;
                          setState(() {});
                          _deviceHttpClient.restartDevice();
                        },
                      ),
                      DropdownItem(
                        label: 'Shutdown',
                        onChanged: () {
                          if (!userProvider.isSignedIn) {
                            showNotSignInWarning(context);
                            return;
                          }
                          _statusColor = Colors.red;
                          setState(() {});
                          _deviceHttpClient.shutdownDevice();
                        },
                      ),
                    ],
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
