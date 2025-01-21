import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:servenow_mobile/services/tasker_auth.dart';

class TaskerEStatement {
  Future<Map<String, dynamic>> getEStatement() async {
    try {
      final token = await TaskerAuth().getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-e-statement');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (response.body.isNotEmpty) {
        final data = json.decode(response.body);

        return {
          'statusCode': response.statusCode,
          'data': data['data'],
          'tobeReleased': data['tobeReleased'],
          'releasedthisyear': data['releasedthisyear'],
          'releasedAll': data['releasedAll'],

          'monthlyReleasedAmounts': data['monthlyReleasedAmounts'],
          'yearlyReleasedAmounts': data['yearlyReleasedAmounts'],
        };
      } else {
        throw Exception('Failed to get booking list');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }
}
