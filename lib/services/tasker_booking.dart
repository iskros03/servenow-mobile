import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:http/http.dart' as http;

class TaskerBooking {
  Future<Map<String, dynamic>> getTaskerBookingDetails() async {
    try {
      final token = await TaskerAuth().getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-bookings-details');
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

  Future<Map<String, dynamic>> getUnavailableSlot() async {
    try {
      final token = await TaskerAuth().getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-unavailable-time');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'data': data,
        };
      } else {
        throw Exception('Failed to get tasker data');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> updateBookingSchedule(
      Map<String, dynamic> updateBooking) async {
    try {
      final token = await TaskerAuth().getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/booking-reschedule');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(updateBooking),
      );

      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'data': data,
        };
      } else {
        throw Exception('Failed to update booking.');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> changeBookingStatus(
      Map<String, dynamic> changeBooking) async {
    try {
      final token = await TaskerAuth().getToken();
      final url =
          Uri.parse('${dotenv.env['DOMAIN']}/api/change-booking-status');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(changeBooking),
      );
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        print(data);
        return {
          'statusCode': response.statusCode,
          'data': data,
        };
      } else {
        throw Exception('Failed to update booking.');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

  Future<Map<String, dynamic>> getBookingList() async {
    try {
      final token = await TaskerAuth().getToken();
      final url = Uri.parse('${dotenv.env['DOMAIN']}/api/get-booking-list');
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
          'monthlyChartData': data['monthlyChartData'],
          'yearlyChartData': data['yearlyChartData'],
          'totalBooking': data['totalBooking'],
          'totalUnpaid': data['totalUnpaid'],
          'totalConfirmed': data['totalConfirmed'],
          'totalCompleted': data['totalCompleted'],
          'totalCancelled': data['totalCancelled'],
          'totalCompletedAmount': data['totalCompletedAmount'],
          'totalCancelledAmount': data['totalCancelledAmount'],
          'totalFloatingAmount': data['totalFloatingAmount'],
          'totalCompletedAmountThisMonth': data['totalCompletedAmountThisMonth'],
        };
      } else {
        throw Exception('Failed to get booking list');
      }
    } catch (e) {
      throw Exception("Failed to fetch API: $e");
    }
  }

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
}
