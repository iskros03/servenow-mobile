import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:http/http.dart' as http;

class TaskerBooking {
  Future<Map<String, dynamic>> getTaskerBookingDetails() async {
    try {
      final token = await TaskerAuth().getToken();
      final domain = dotenv.env['DOMAIN'];

      final url = Uri.parse('$domain/api/get-bookings-details');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);
          if (responseData.containsKey('booking')) {
            return {
              'statusCode': response.statusCode,
              'booking': responseData['booking'],
            };
          } else {
            throw Exception('Invalid response format: Missing "booking" key');
          }
        } else {
          throw Exception('Response body is empty.');
        }
      } else {
        throw Exception(
            'Failed to fetch booking details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }
}
