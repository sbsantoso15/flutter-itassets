import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Make sure to import your login screen

Future<void> logout(BuildContext context) async {
  // Clear the stored token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs
      .remove('auth_token'); // Assuming you saved token with key 'auth_token'

  // Show a SnackBar to notify the user
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Logged out successfully!')));

  // Navigate to the login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) =>
            const LoginPage()), // Replace with your login screen
  );
}
