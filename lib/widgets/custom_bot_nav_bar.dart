import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBotNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBotNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.grey.shade700,
      unselectedItemColor: Colors.grey.shade400,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.hammer, size: 18),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.calendarCheck, size: 18),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.houseChimney, size: 18),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.gears, size: 18),
          label: 'Preferences',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.magnifyingGlassChart, size: 18),
          label: 'Performance',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.fileInvoiceDollar, size: 18),
          label: 'e-Statement',
        ),
      ],
    );
  }
}
