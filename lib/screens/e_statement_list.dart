import 'package:flutter/material.dart';

class EStatementList extends StatefulWidget {
  const EStatementList({super.key});

  @override
  State<EStatementList> createState() => _EStatementListState();
}

class _EStatementListState extends State<EStatementList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'e-Statement List',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }
}
