import 'package:flutter/material.dart';
import 'package:robotic_dashboard/responsive/responsive.dart';
import 'package:robotic_dashboard/service/device_http_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
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
                headerText: 'ROBOTIC DASHBOARD',
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
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: SizedBox(
        height: 315,
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border:
                  Border.all(color: const Color.fromARGB(255, 193, 193, 193))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "robotics_default",
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child:
                            Icon(Icons.circle, color: _statusColor, size: 17),
                      ),
                    ],
                  ),
                  CustomDropdownButton(
                    header: const DropdownHeader(),
                    dropDownItems: [
                      DropdownItem(
                        text: 'Update',
                        icon: Icons.update,
                        onSelected: () {},
                      ),
                      DropdownItem(
                        text: 'Shutdown',
                        icon: Icons.logout,
                        onSelected: () {
                          _statusColor = Colors.red;
                          setState(() {});
                          _deviceHttpClient.shutdownDevice();
                        },
                      ),
                      DropdownItem(
                        text: 'Reboot',
                        icon: Icons.restart_alt,
                        onSelected: () {
                          _statusColor = Colors.red;
                          setState(() {});
                          _deviceHttpClient.restartDevice();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 8.0),
            const Expanded(child: DeviceInfoList())
          ]),
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
              border:
                  Border.all(color: const Color.fromARGB(255, 193, 193, 193))),
          child: const Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                  child: Text(
                    "Services",
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Row(
                    children: [],
                  ),
                ),
              ]),
              // SizedBox(
              //   height: defaultPadding,
              // ),
              Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: Divider(),
              ),
              Expanded(child: ServiceManager()),
            ],
          ),
        ),
      ),
    );
  }
}
