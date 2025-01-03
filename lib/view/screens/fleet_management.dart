import 'package:flutter/material.dart';
import 'package:robotic_dashboard/responsive/responsive.dart';
import 'package:robotic_dashboard/utils/constants.dart';
import 'package:robotic_dashboard/view/components/header.dart';
import 'package:robotic_dashboard/view/screens/side_menu.dart';

class FleetManagement extends StatelessWidget {
  const FleetManagement({
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
                headerText: 'FLEET MANAGEMENT',
              ),
              // DeviceInfo(),
              // ControllerDashboard(),
              // SizedBox(
              //   height: defaultPadding,
              // ),
            ],
          ),
        ),
      ],
    ));
  }
}
