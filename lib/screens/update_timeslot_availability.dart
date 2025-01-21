import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';

class UpdateTimeslotAvailability extends StatefulWidget {
  final dynamic slotStatus;
  final dynamic slotId;

  const UpdateTimeslotAvailability({super.key, this.slotStatus, this.slotId});

  @override
  State<UpdateTimeslotAvailability> createState() =>
      _UpdateTimeslotAvailabilityState();
}

class _UpdateTimeslotAvailabilityState
    extends State<UpdateTimeslotAvailability> {
  dynamic taskerSlotId;
  dynamic taskerSlotStatus;
  String? availabilityTitle;
  dynamic selectedAvailability;

  @override
  void initState() {
    super.initState();
    taskerSlotId = '${widget.slotId}';
    taskerSlotStatus = widget.slotStatus; // Assuming slotStatus is 0 or 1.
    availabilityTitle = taskerSlotStatus == 1 ? 'Available' : 'Unavailable';
    selectedAvailability = taskerSlotStatus; // Set it to 0 or 1
  }

  final List<String> timeslotAvailability = [
    'Available',
    'Unavailable',
  ];

  Future<void> changeTimeSlotAvailablility() async {
    try {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.grey.shade200,
      //     content: Center(
      //       child: Text(
      //         'Loading...',
      //         style: TextStyle(
      //           fontFamily: 'Inter',
      //           color: Colors.grey.shade800,
      //           fontWeight: FontWeight.normal,
      //           fontSize: 13,
      //         ),
      //       ),
      //     ),
      //     duration: Duration(seconds: 3),
      //   ),
      // );

      TaskerService taskerService = TaskerService();
      final response = await taskerService.changeTimeSlotAvailablility(
          taskerSlotId, selectedAvailability.toString());

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                response['data']['data'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
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
          'Update Availability',
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
                    child: Text(
                      'Time Slot Availability',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ),
                  ),
                  CustomDropdownMenu(
                    titleValue: availabilityTitle,
                    titleSelect: 'Select Availability',
                    items: timeslotAvailability,
                    onSelected: (selectedValue) {
                      setState(() {
                        if (selectedValue == 'Available') {
                          selectedAvailability = 1;
                          availabilityTitle = 'Available';
                        } else if (selectedValue == 'Unavailable') {
                          selectedAvailability = 0;
                          availabilityTitle = 'Unavailable';
                        }
                        changeTimeSlotAvailablility();
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
