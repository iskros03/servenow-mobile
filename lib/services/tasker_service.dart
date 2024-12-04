import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskerService {
  Future<List<dynamic>> getTaskerServiceType() async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-service-type');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print(response.body);

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body)['servicetype'];
        return data;
      } else {
        throw Exception('Failed to get tasker data');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<List<dynamic>> getTaskerServiceList() async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-service-list');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body)['service'];
        return data;
      } else {
        throw Exception('Failed to get tasker data');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> createTaskerService(
      Map<String, dynamic> createService) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/create-service');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(createService),
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
      throw Exception("Failed to fetch API: $e");
    }
  }
}