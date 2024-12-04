import 'package:flutter/material.dart';

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
      selectedItemColor: const Color.fromRGBO(24, 52, 92, 1),
      unselectedItemColor: const Color.fromARGB(125, 24, 52, 92),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            color: Color.fromRGBO(24, 52, 92, 1),
          ),
          label: 'Add Service',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Settings',
        ),
      ],
    );
  }
}
