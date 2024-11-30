import 'package:flutter/material.dart';

class ApiConfig with ChangeNotifier {
  String _apiUrl = "http://192.168.3.32/itassets/api/"; // Default API URL

  String get apiUrl => _apiUrl;

  set apiUrl(String newUrl) {
    _apiUrl = newUrl;
    notifyListeners(); // Notify listeners when the URL changes
  }
}
