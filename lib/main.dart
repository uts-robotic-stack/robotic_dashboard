import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:robotic_dashboard/service/device_provider.dart';
import 'package:robotic_dashboard/service/navigation_provider.dart';
import 'package:robotic_dashboard/service/user_client.dart';
import 'package:robotic_dashboard/service/service_log_ws_client.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/view/screens/mainscreen.dart';

/// The main entry point of the application.
void main() async {
  // Load environment variables from the appropriate .env file based on the environment.
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(fileName: env == 'prod' ? '.env.prod' : '.env');

  // Run the application with multiple providers.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ServiceLogsWSClient()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => DeviceProvider())
  ], child: const RoboticsDashboard()));
}

/// The main widget for the Robotics Dashboard application.
class RoboticsDashboard extends StatelessWidget {
  const RoboticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robotics Dashboard',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: secondaryColor,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
              bodyColor: Colors.black,
            ),
        canvasColor: primaryColor,
      ),
      home: const MainScreen(),
    );
  }
}
