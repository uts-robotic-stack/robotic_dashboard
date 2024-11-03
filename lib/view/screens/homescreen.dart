import 'package:flutter/material.dart';
import 'package:robotics_dashboard/responsive/responsive.dart';
import 'package:robotics_dashboard/utils/constants.dart';
import 'package:robotics_dashboard/view/components/dashboard_header.dart';
import 'package:robotics_dashboard/view/components/device_info.dart';
import 'package:robotics_dashboard/view/components/log_viewer.dart';
import 'package:robotics_dashboard/view/components/service_manager.dart';
import 'package:robotics_dashboard/view/screens/side_menu.dart';
import 'package:robotics_dashboard/view/widgets/dropdown_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FractionallySizedBox(
      widthFactor: screenWidth < 1480 ? 1.0 : 1480 / screenWidth,
      child: Scaffold(
          drawer: const SideMenu(),
          body: SafeArea(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const SizedBox(width: defaultSideMenuWidth, child: SideMenu()),
              const Expanded(
                flex: 1,
                child: Column(
                  children: [
                    DashboardHeader(),
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
          ))),
    );
  }
}

class DeviceInfo extends StatelessWidget {
  const DeviceInfo({
    super.key,
  });

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
                  const Text(
                    "robotics_default",
                    style: TextStyle(fontSize: 18),
                  ),
                  CustomDropdownButton(
                    header: const DropdownHeader(),
                    dropDownItems: [
                      DropdownItem(
                        text: 'Update',
                        icon: Icons.update,
                        onSelected: () {
                          // Implement Shutdown functionality
                        },
                      ),
                      DropdownItem(
                        text: 'Shut down',
                        icon: Icons.logout,
                        onSelected: () {
                          // Implement Shutdown functionality
                        },
                      ),
                      DropdownItem(
                        text: 'Reboot',
                        icon: Icons.restart_alt,
                        onSelected: () {
                          // Implement Shutdown functionality
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
                  padding: EdgeInsets.all(defaultPadding / 2),
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
              SizedBox(
                height: defaultPadding,
              ),
              Expanded(child: ServiceManager()),
            ],
          ),
        ),
      ),
    );
  }
}
