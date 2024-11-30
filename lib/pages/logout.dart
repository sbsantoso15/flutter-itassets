// import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'home_page.dart';

Future<void> logout() async {
  // Get token from SharedPreferences
  //BuildContext context;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  if (token == null) {
    //print('No token found, user is not logged in.');
    return;
  }

  final url = Uri.parse('http://192.168.3.32/itassets/api/logout');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Token deleted successfully
    await prefs.remove('auth_token');
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Logged out successfully!')));

    // print('Logged out successfully!');
    if (Platform.isAndroid || Platform.isIOS) {
      SystemNavigator.pop(); // Android/iOS
    } else {
      exit(0); // Force exit for other platforms (not recommended)
    }
  } else {
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Logged out successfully!')));
    print('Logout failed: ${response.body}');
  }
}
