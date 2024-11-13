import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;
  bool _isMaintainer = false;
  bool get isMaintainer => _isMaintainer;

  String? _token; // Store JWT token for authenticated requests
  String? get token => _token;
  bool _signedIn = false;
  bool get isSignedIn => _signedIn;

  String? _name;
  String get name => _name ?? "observer";

  final String _baseUrl = dotenv.env['BASE_URL'] ??
      const String.fromEnvironment("BASE_URL",
          defaultValue: "192.168.27.1:8080");

  Future<void> signIn(String username, String password) async {
    _name = username;
    if (_signedIn) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://$_baseUrl/api/v1/signin'),
        headers: <String, String>{
          'Content-Type': "application/json",
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if the token is provided in the response
        if (responseData.containsKey('token')) {
          _token = responseData['token'];
          _signedIn = true;
          // Fetch the user's role using the token
          await _fetchUserRole();
        } else {
          // If no token is provided, assume the user is a regular user
          _token = null;
          _signedIn = true;
          _isMaintainer = false;
          _isAdmin = false;
        }
        notifyListeners();
      } else {
        throw Exception('Failed to sign in: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error during sign in: $error');
    }
  }

  Future<void> _fetchUserRole() async {
    if (_token == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://$_baseUrl/api/v1/signin/role'),
        headers: <String, String>{
          'Authorization': _token!,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _isAdmin = responseData['role'] == 'admin';
        _isMaintainer = responseData['role'] == 'maintainer';
      } else {
        _isAdmin = false;
        _isMaintainer = false;
        throw Exception('Failed to fetch user role: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error during fetching role: $error');
    }
  }

  // Sign out method to clear the user's session
  void signOut() {
    _isAdmin = false;
    _token = null;
    _signedIn = false;
    notifyListeners();
  }
}
