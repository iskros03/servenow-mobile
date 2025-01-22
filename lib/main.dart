import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:servenow_mobile/screens/add_service.dart';
import 'package:servenow_mobile/screens/booking_details.dart';
import 'package:servenow_mobile/screens/booking_list.dart';
import 'package:servenow_mobile/screens/booking_summary.dart';
import 'package:servenow_mobile/screens/dashboard.dart';
import 'package:servenow_mobile/screens/e_statement.dart';
import 'package:servenow_mobile/screens/e_statement_list.dart';
import 'package:servenow_mobile/screens/home.dart';
import 'package:servenow_mobile/screens/manage_service.dart';
import 'package:servenow_mobile/screens/my_booking.dart';
import 'package:servenow_mobile/screens/my_profile.dart';
import 'package:servenow_mobile/screens/refund_booking_list.dart';
import 'package:servenow_mobile/screens/refund_booking_summary.dart';
import 'package:servenow_mobile/screens/review_list.dart';
import 'package:servenow_mobile/screens/review_management.dart';
import 'package:servenow_mobile/screens/review_summary.dart';
import 'package:servenow_mobile/screens/settings.dart';
import 'package:servenow_mobile/screens/services.dart';
import 'package:servenow_mobile/screens/sign_in.dart';
import 'package:servenow_mobile/screens/sign_up.dart';
import 'package:servenow_mobile/screens/task_preferences.dart';
import 'package:servenow_mobile/screens/update_timeslot_availability.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/sign_in',
      routes: {
        '/home': (context) => const Home(),
        '/sign_in': (context) => const SignIn(),
        '/sign_up': (context) => const SignUp(),
        '/settings': (context) => const Settings(),
        '/my_profile': (context) => const MyProfile(),
        '/services': (context) => const Services(),
        '/add_service': (context) => const AddService(),
        '/manage_service': (context) => const ManageService(),
        '/task_prefences': (context) => const TaskPreferences(),
        '/my_booking': (context) => const MyBooking(),
        '/update_time_slot': (context) => const UpdateTimeslotAvailability(),
        '/booking_details': (context) => const BookingDetails(),
        '/booking_summary': (context) => const BookingSummary(),
        '/booking_list': (context) => const BookingList(),
        '/review_summary': (context) => const ReviewSummary(),
        '/review_list': (context) => const ReviewList(),
        '/review_management': (context) => const ReviewManagement(),
        '/refund_booking_summary': (context) => const RefundBookingSummary(),
        '/refund_booking_list': (context) => const RefundBookingList(),
        '/dashboard': (context) => const Dashboard(),
        '/e_statement': (context) => const EStatement(),
        '/e_statement_list': (context) => const EStatementList(),
      }));
}
