import 'package:flutter/material.dart';

class ManageService extends StatefulWidget {
  const ManageService({super.key});

  @override
  State<ManageService> createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Manage Service'),
      ),
    ));
  }
}
