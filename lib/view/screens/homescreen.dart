import 'package:flutter/material.dart';
import 'package:robotics_dashboard/responsive/responsive.dart';
import 'package:robotics_dashboard/utils/constants.dart';
import 'package:robotics_dashboard/view/components/dashboard_header.dart';
import 'package:robotics_dashboard/view/components/log_viewer.dart';
import 'package:robotics_dashboard/view/screens/side_menu.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    return Scaffold(
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
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: DeviceInfo(),
                  ),
                  ControllerDashboard()
                ],
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(flex: 1, child: LogsViewer())
          ],
        )));
  }
}

class DeviceInfo extends StatelessWidget {
  const DeviceInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Color.fromARGB(255, 193, 193, 193))),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4.0, left: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "robotics_default",
                      style: TextStyle(fontSize: 18),
                    ),
                    ActionSettings(),
                  ],
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Text(
                "Device: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Last on: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Duration: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Software version: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "IP address: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "MAC address: ",
                style: TextStyle(fontSize: 16),
              ),
            ]),
      ),
    );
  }
}

class ActionSettings extends StatefulWidget {
  const ActionSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActionSettingsState createState() => _ActionSettingsState();
}

class _ActionSettingsState extends State<ActionSettings> {
  String dropdownValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          width: 120,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 90, 90, 90),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings,
                size: 25,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Action", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(
              enabled: false,
              child: Divider(
                color: Colors.white,
              )),
          ...MenuItems.secondItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value! as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
          offset: const Offset(0, -5),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [update, reboot];
  static const List<MenuItem> secondItems = [shutdown];

  static const reboot = MenuItem(text: 'Reboot', icon: Icons.restart_alt);
  static const update = MenuItem(text: 'Update', icon: Icons.update);
  static const shutdown = MenuItem(text: 'Shutdown', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.reboot:
        break;
      case MenuItems.shutdown:
        break;
    }
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
                  Border.all(color: const Color.fromARGB(255, 107, 107, 107))),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Padding(
                  padding: EdgeInsets.all(defaultPadding / 2),
                  child: Text(
                    "Services",
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 20.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.pause,
                          size: 20.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.stop,
                          size: 20.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.restart_alt,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(
                height: defaultPadding,
              ),
              Divider(
                indent: 0.0,
                endIndent: 0.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const ServiceCardWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCardWidget extends StatelessWidget {
  const ServiceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 120,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color.fromARGB(26, 0, 0, 0))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Logs",
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.pause,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.stop,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.restart_alt,
                            size: 17.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.document_scanner,
                            size: 17.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
