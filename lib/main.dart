import 'package:flutter/material.dart';
import 'package:robotics_dashboard/view/screens/homescreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const RoboticsDashboard());
}

class RoboticsDashboard extends StatelessWidget {
  const RoboticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Device Management Dashboard',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: Colors.white60,
      ),
      home: const HomeScreen(),
    );
  }
}
