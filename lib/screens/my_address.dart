import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final List<String> state = [
    'Johor',
    'Melaka',
    'Selangor',
  ];
  String? selectedState;
  final TextEditingController taskerAddressOne = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(24, 52, 92, 1),
        title: Text(
          'Address',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                cardColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.circleInfo,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 7.5),
                        Text(
                          'Note',
                          style: TextStyle(
                              color: Colors.blue[600],
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Change will take up to 5 minutes',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTextField('Address Line 1', taskerAddressOne,
                  obscureText: true),
              _buildTextField('Address Line 2', taskerAddressOne,
                  obscureText: true),
              _buildTextField('Postal Code', taskerAddressOne,
                  obscureText: true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.5),
                      Text(
                        'State',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'Inter',
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.5),
                  CustomDropdownMenu(
                      items: state,
                      titleSelect: 'Select State',
                      onSelected: (selectedValue) {
                        selectedState = selectedValue;
                        print(selectedValue);
                      }),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.5),
                      Text(
                        'Area',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'Inter',
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.5),
                  CustomDropdownMenu(
                      items: state,
                      titleSelect: 'Select Area',
                      onSelected: (selectedValue) {
                        selectedState = selectedValue;
                        print(selectedValue);
                      }),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 12.5),
            Text(
              label,
              style: TextStyle(
                  color: Colors.grey[600], fontFamily: 'Inter', fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 2.5),
        CustomTextField(
          maxLines: maxLines,
          controller: controller,
          obscureText: obscureText,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
