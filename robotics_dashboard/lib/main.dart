import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:robotics_dashboard/view/screens/homescreen.dart';

void main() {
  runApp(const RoboticsDashboard());
}

class RoboticsDashboard extends StatelessWidget {
  const RoboticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.resize(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      home: const HomeScreen(),
    );
  }
}
