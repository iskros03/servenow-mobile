import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskerAuth {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<dynamic> getTaskerAuth(
      BuildContext context, String email, String password) async {
    try {
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/authenticate-tasker');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'data': responseData,
        };
      } else {
        throw Exception('No response body received');
      }
    } catch (e) {
      throw Exception('Failed to fetch API: $e');
    }
  }

  Future<bool> getTaskerLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('auth_token');

    // Or clear all stored data
    // await prefs.clear();
  }

  Future<Map<String, dynamic>> updateTaskerPassword(
      String id, Map<String, dynamic> updatedPassword) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/update-password-$id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(updatedPassword),
      );
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        return {
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update tasker data: $e');
    }
  }
}
