import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:servenow_mobile/services/tasker_auth.dart';

class TaskerUser {
  Future<List<dynamic>> getTaskerData() async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-tasker-details');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body)['data'];
        return data;
      } else {
        throw Exception('Failed to get tasker data');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<List<String>> getState() async {
    try {
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-state');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 201 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        final states = data['state']['states'] as List;
        final stateNames =
            states.map((state) => state['name'] as String).toList();

        return stateNames;
      } else {
        throw Exception('Failed to fetch state names: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<List<String>> getArea(String state) async {
    try {
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-area-$state');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return List<String>.from(data);
      } else {
        throw Exception('Failed to fetch area names: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> updateTaskerData(
      String id, Map<String, dynamic> updatedData) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/update-profile-$id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(updatedData),
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
      throw Exception('Failed to fetch API: $e');
    }
  }
}
