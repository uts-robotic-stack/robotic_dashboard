import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotics_dashboard/service/user_client.dart';
import 'package:robotics_dashboard/service/service_log_ws_client.dart';
import 'package:robotics_dashboard/utils/constants.dart';
import 'package:robotics_dashboard/view/screens/homescreen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ServiceLogsWSClient()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ], child: const RoboticsDashboard()));
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
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
              bodyColor: Colors.black,
            ),
        canvasColor: primaryColor,
      ),
      home: const HomeScreen(),
    );
  }
}
