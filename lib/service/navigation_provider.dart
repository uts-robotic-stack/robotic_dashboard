import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  String _selectedPage = "dashboard";

  String get selectedPage => _selectedPage;

  void setPage(String page) {
    _selectedPage = page;
    notifyListeners();
  }
}
