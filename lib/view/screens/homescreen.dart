import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        body: Stack(
          children: [
            GestureDetector(
              onHorizontalDragEnd: (details) {
                double screenWidth = MediaQuery.of(context).size.width;
                if (screenWidth <= 800 &&
                    details.primaryVelocity != null &&
                    details.primaryVelocity! > 0) {
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
                      visibleWhen: const [Condition.equals(name: DESKTOP)],
                      child: Container(
                        width: 100,
                        child: SideMenu(),
                      ),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    columnFlex: 1,
                    rowFit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('ROBOTICS DASHBOARD',
                                  style: TextStyle(fontSize: 24)),
                            ),
                            SizedBox(height: 16),
                          ]),
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
          ],
        ));
  }
}
