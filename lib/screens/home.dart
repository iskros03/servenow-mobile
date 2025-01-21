import 'package:flutter/material.dart';
import 'package:servenow_mobile/screens/dashboard.dart';
import 'package:servenow_mobile/screens/e_statement.dart';
import 'package:servenow_mobile/screens/my_booking.dart';
import 'package:servenow_mobile/screens/review_summary.dart';
import 'package:servenow_mobile/screens/services.dart';
import 'package:servenow_mobile/screens/task_preferences.dart';
import 'package:servenow_mobile/widgets/custom_bot_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 2;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Services(showLeadingIcon: _currentIndex == 0 ? false : true),
          MyBooking(showLeadingIcon: _currentIndex == 1 ? false : true),
          Dashboard(),
          TaskPreferences(showLeadingIcon: _currentIndex == 3 ? false : true),
          ReviewSummary(showLeadingIcon: _currentIndex == 4 ? false : true),
          EStatement(showLeadingIcon: _currentIndex == 5 ? false : true),
        ],
      ),
      bottomNavigationBar: CustomBotNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
