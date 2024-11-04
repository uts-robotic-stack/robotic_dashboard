// navigation_provider.dart
import 'package:flutter/material.dart';
import 'package:robotics_dashboard/view/screens/homescreen.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
