import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: 100,
        child: Drawer(
          child: SideMenu(),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: ResponsiveRowColumn(
          rowMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.start,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          layout: ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          children: [
            ResponsiveRowColumnItem(
              child: ResponsiveVisibility(
                visible: false,
                visibleWhen: [Condition.equals(name: DESKTOP)],
                child: Container(
                  width: 100,
                  child: SideMenu(),
                ),
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              columnFlex: 1,
              child: Container(
                color: Colors.red,
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              columnFlex: 1,
              child: Container(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stack(
//         children: [
//           ResponsiveVisibility(
//             visible: false,
//             visibleWhen: [Condition.equals(name: DESKTOP)],
//             child: Container(
//               width: 100,
//               child: SideMenu(),
//             ),
//           ),
//           ResponsiveVisibility(
//             visible: true,
//             hiddenWhen: [Condition.equals(name: DESKTOP)],
//             child: IconButton(
//               icon: Icon(
//                 Icons.menu,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 _scaffoldKey.currentState!.openDrawer();
//               },
//             ),
//           ),
//         ],
//       ),
