import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  String? _token; // Store JWT token for authenticated requests
  String? get token => _token;
  bool _signedIn = false;

  final String _baseUrl = dotenv.env['BASE_URL'] ??
      const String.fromEnvironment("BASE_URL", defaultValue: "10.211.55.7");

  Future<void> signIn(String username, String password) async {
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
        _token = responseData['token'];
        _signedIn = true;

        // Fetch the user's role using the token
        await _fetchUserRole();

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
        if (responseData['role'] == 'admin') {
          _isAdmin = true;
        } else {
          _isAdmin = false;
        }
      } else {
        _isAdmin = false;
        throw Exception('Failed to fetch user role: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error during fetching role: $error');
    }
  }

  void signOut() {
    _isAdmin = false;
    _token = null;
    notifyListeners();
  }
}
