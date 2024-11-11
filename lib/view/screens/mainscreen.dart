import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/navigation_provider.dart';
import 'package:robotic_dashboard/view/screens/dashboard.dart';
import 'package:robotic_dashboard/view/screens/fleet_management.dart';
import 'package:robotic_dashboard/view/screens/settings.dart';
import 'package:robotic_dashboard/view/screens/side_menu.dart';
import 'package:robotic_dashboard/view/screens/statistic.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const Map<String, Widget> pages = {
    'dashboard': Dashboard(),
    'stats': StatisticScreen(),
    'settings': SettingsScreen(),
    'fleet': FleetManagement()
  };
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final selectedPage = context.watch<NavigationProvider>().selectedPage;
    return FractionallySizedBox(
      widthFactor: screenWidth < 1480 ? 1.0 : 1480 / screenWidth,
      child: Scaffold(
          drawer: const SideMenu(),
          body: pages[selectedPage] ?? const Dashboard()),
    );
  }
}
