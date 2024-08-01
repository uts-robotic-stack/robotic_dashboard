import 'package:flutter/material.dart';
import 'package:robotics_dashboard/utils/constants.dart';
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
      title: 'Robotics Dashboard',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: primaryColor,
      ),
      home: const HomeScreen(),
    );
  }
}
