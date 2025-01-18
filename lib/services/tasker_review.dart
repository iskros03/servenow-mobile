import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskerReview {
  Future<Map<String, dynamic>> getReviewList() async {
    try {
      final token = await TaskerAuth().getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-review-list');
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
          'reply': data['reply'],
          'rating5Count': data['rating5Count'],
          'rating4Count': data['rating4Count'],
          'rating3Count': data['rating3Count'],
          'rating2Count': data['rating2Count'],
          'rating1Count': data['rating1Count'],
          'totalreviewsbymonth': data['totalreviewsbymonth'],
          'totalunreview': data['totalunreview'],
          'averageRating': data['averageRating'],
          'csat': data['csat'],
          'negrev': data['negrev'],
          'neutralrev': data['neutralrev'],
        };
      } else {
        throw Exception('Failed to get booking list');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> changeReviewAvailablility(
      int id, int reviewStatus) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/update-review-$id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'review_status': reviewStatus,
        }),
      );

      if (response.body.isNotEmpty) {
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

  Future<Map<String, dynamic>> replyreview(int id, String taskerReply) async {
    final TaskerAuth taskerAuth = TaskerAuth();
    try {
      final token = await taskerAuth.getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/tasker-reply-review/$id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'reply_message': taskerReply,
        }),
      );
      if (response.body.isNotEmpty) {
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
}
