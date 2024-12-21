import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskerService {
  Future<List<Map<String, dynamic>>> getTaskerServiceType() async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-service-type');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body)['servicetype'];

        final serviceList = (data as List).map((service) {
          return {
            'id': service['id'],
            'servicetype_name': service['servicetype_name'],
          };
        }).toList();
        return serviceList;
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

  Future<Map<String, dynamic>> updateTaskerService(
      String id, Map<String, dynamic> createService) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/update-service-$id');
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

  Future<Map<String, dynamic>> deleteTaskerService(String id) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/delete-service-$id');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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

  Future<Map<String, dynamic>> updateTaskerLocation(
      Map<String, dynamic> updatedLocation) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url =
          Uri.parse('${dotenv.env['DOMAIN']}/api/update-tasker-location');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(updatedLocation),
      );

      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        return {
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        throw Exception('Failed to update location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch API: $e');
    }
  }

  Future<Map<String, dynamic>> saveWorkingType(int taskerWorkType) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url =
          Uri.parse('${dotenv.env['DOMAIN']}/api/tasker-working-type-change');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tasker_worktype': taskerWorkType,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'data': responseData,
        };
      } else {
        throw Exception('Failed to update the working type');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> createTimeSlot(String date) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url =
          Uri.parse('${dotenv.env['DOMAIN']}/api/create-time-slot-$date');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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

  Future<List<Map<String, dynamic>>> getTimeSlot(String date) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url =
          Uri.parse('${dotenv.env['DOMAIN']}/api/get-tasker-time-slot-$date');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Expected "data" to be a list.');
        }
      } else {
        throw Exception('Failed to load time slots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }
}
