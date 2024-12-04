import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskerAuth {
  void showBottomMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Dia return null kalau token tak ada
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var token = data['token'];
        print('Token: $token');
        await saveToken(token);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['error'];
        showBottomMessage(context, '$errorMessage');
        print('Error: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to authenticate tasker: $e');
    }
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
