import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';

class UpdateTimeslotAvailability extends StatefulWidget {
  const UpdateTimeslotAvailability({super.key});

  @override
  State<UpdateTimeslotAvailability> createState() =>
      _UpdateTimeslotAvailabilityState();
}

class _UpdateTimeslotAvailabilityState
    extends State<UpdateTimeslotAvailability> {
  final List<String> timeslotAvailability = [
    'Available',
    'Unavailable',
  ];

  String availabilityTitle = 'Select Availability';
  dynamic selectedAvailability;

  Future<void> changeTimeSlotAvailablility() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update service...'),
          duration: Duration(seconds: 2),
        ),
      );

      TaskerService taskerService = TaskerService();
      final response =
          await taskerService.changeTimeSlotAvailablility('51',selectedAvailability);

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['data']['data']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (response['statusCode'] == 301) {
        throw Exception(response['data']['message']);
      } else {
        throw Exception(response['data']['message']);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Update Time Slot',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: changeTimeSlotAvailablility,
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.orange[300],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'State',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                  CustomDropdownMenu(
                    titleValue: availabilityTitle,
                    titleSelect: 'Select Availability',
                    items: timeslotAvailability,
                    onSelected: (selectedValue) {
                      setState(() {
                        if (selectedValue == 'Available') {
                          selectedAvailability = '1';
                          availabilityTitle = 'Available';
                        } else if (selectedValue == 'Unavailable') {
                          selectedAvailability = '0';
                          availabilityTitle = 'Unavailable';
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
