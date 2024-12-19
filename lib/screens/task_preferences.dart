import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';

class TaskPreferences extends StatefulWidget {
  const TaskPreferences({super.key});

  @override
  State<TaskPreferences> createState() => _TaskPreferencesState();
}

class _TaskPreferencesState extends State<TaskPreferences> {
  late Future<Map<String, String>> taskerDataFuture;
  late Map<String, String> initialTaskerData;

  bool isPublic = true;

  String? selectedDate;

  List<String> states = [];
  List<String> areas = [];
  final List<String> workingType = [
    'Full Time',
    'Part Time',
  ];

  String? workingLocState;
  String? workingLocArea;

  String? selectedWorkingType;
  int? selectedWorkingTypeValue;

  Map<String, int> workingTypeMap = {
    'Full Time': 1,
    'Part Time': 2,
  };

  @override
  void initState() {
    super.initState();

    taskerDataFuture = _loadTaskerData();
    fetchStateNames();

    DateTime firstDate = DateTime.now(); // Today
    selectedDate = DateFormat('yyyy-MM-dd').format(firstDate);
    _getTimeSlot('$selectedDate');
  }

  void fetchStateNames() async {
    TaskerUser getState = TaskerUser();
    try {
      final stateNames = await getState.getState();
      setState(() {
        states = stateNames;
      });
      final taskerData = await taskerDataFuture;
      if (taskerData['tasker_workingloc_state'] != null) {
        fetchAreaNames(taskerData['tasker_workingloc_state']!);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchAreaNames(String selectedArea) async {
    TaskerUser getArea = TaskerUser();
    try {
      final areaNames = await getArea.getArea(selectedArea);
      setState(() {
        areas = areaNames;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Map<String, String>> _loadTaskerData() async {
    TaskerUser taskerUser = TaskerUser();
    try {
      await Future.delayed(const Duration(seconds: 1));
      var data = await taskerUser.getTaskerData();

      workingLocState = data[0]['tasker_workingloc_state'];
      workingLocArea = data[0]['tasker_workingloc_area'];

      initialTaskerData = {
        'tasker_workingloc_state': data[0]['tasker_workingloc_state'],
        'tasker_workingloc_area': data[0]['tasker_workingloc_area'],
      };
      return initialTaskerData;
    } catch (e) {
      print('Error occurred: $e');
      return {};
    }
  }

  void _saveWorkingPreferredLocation() async {
    final updatedLocation = {
      'tasker_workingloc_state': workingLocState,
      'tasker_workingloc_area': workingLocArea,
    };

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving...'),
          duration: Duration(seconds: 1),
        ),
      );

      TaskerService taskerService = TaskerService();

      final response =
          await taskerService.updateTaskerLocation(updatedLocation);
      final responseData = response['data'];

      if (response['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw responseData['message'];
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _saveWorkingType() async {
    try {
      TaskerService taskerService = TaskerService();
      final response =
          await taskerService.saveWorkingType(selectedWorkingTypeValue!);

      if (response['statusCode'] == 200) {
        print("Working type updated successfully.");
      } else {
        print("Failed to update working type.");
      }
    } catch (e) {
      print("$e");
    }
  }

  void _createTimeSlot() async {
    try {
      TaskerService taskerService = TaskerService();
      final response = await taskerService.createTimeSlot('$selectedDate');
      print(response);
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Map<String, dynamic>> timeSlots = [];

  void _getTimeSlot(String date) async {
    try {
      TaskerService taskerService = TaskerService();
      final result = await taskerService.getTimeSlot(date);
      setState(() {
        timeSlots = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching time slots: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          title: const Text(
            'Task Preferences',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Visibility & Location'),
              Tab(text: 'Time Slot'),
            ],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: _saveWorkingPreferredLocation,
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
        body: TabBarView(
          children: [
            // Visibility & Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Profile Visibility',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        Transform.scale(
                          scale:
                              0.85, // Reduce the size of the Switch if needed
                          child: Switch(
                            value: isPublic,
                            onChanged: (value) {
                              setState(() {
                                isPublic = value;
                              });
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.grey,
                            activeTrackColor: Colors.greenAccent,
                            inactiveTrackColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Visibility(
                    visible: isPublic, // Show only if Public is selected
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Working Preferred Location',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 12.5),
                            Text(
                              'State',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2.5),
                        CustomDropdownMenu(
                          items: states,
                          titleSelect: 'Select State',
                          titleValue: workingLocState ?? 'Select State',
                          onSelected: (selectedValue) {
                            setState(() {
                              workingLocState = selectedValue;
                              workingLocArea = null;
                            });
                            fetchAreaNames(selectedValue);
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 12.5),
                            Text(
                              'Area',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2.5),
                        CustomDropdownMenu(
                          items: areas,
                          titleSelect: 'Select Area',
                          titleValue: workingLocArea ?? 'Select Area',
                          onSelected: (selectedValue) {
                            setState(() {
                              workingLocArea = selectedValue;
                            });
                          },
                          isEnabled: states.isNotEmpty,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Time Slot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                  SizedBox(height: 25),
                  Text(
                    'Date',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.grey[800]),
                  ),
                  SizedBox(height: 5),
                  WeekButtons(
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    onGetTimeSlot: (date) {},
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Preferred Working Type',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.grey[800]),
                  ),
                  SizedBox(height: 5),
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
                                'Full time - (7:30 AM to 7:30 PM), Part time - (2:30 PM to 7:30 PM)',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                        CustomDropdownMenu(
                          items: workingTypeMap.keys
                              .toList(), // This will be the list of items from the map keys
                          titleSelect: 'Select Working Type',
                          titleValue:
                              selectedWorkingType ?? 'Select Working Type',
                          onSelected: (selectedValue) {
                            setState(() {
                              selectedWorkingType = selectedValue;
                              selectedWorkingTypeValue =
                                  workingTypeMap[selectedValue];
                              print(
                                  'Working type: $selectedWorkingType, Value: $selectedWorkingTypeValue');
                            });

                            _saveWorkingType();
                          },
                        ),
                      ],
                    ),
                  ),
                  timeSlots.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: timeSlots.length,
                          itemBuilder: (context, index) {
                            final timeSlot = timeSlots[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time Slot: ${timeSlot['time'] ?? 'N/A'}', // Replace with actual key from your map
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Slot Date: ${timeSlot['slot_date'] ?? 'No details available'}', // Replace with actual key from your map
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          child: Text(
                            'No time slots available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                  SizedBox(height: 25),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     color: Colors.grey[100],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         width: 100,
                  //         padding: EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(10)),
                  //           color: Colors.pinkAccent[400],
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             'Unavailable',
                  //             style: TextStyle(
                  //                 fontFamily: 'Inter',
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 12,
                  //                 color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Row(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(12.0),
                  //               child: Text(
                  //                 '11:30:00',
                  //                 style: TextStyle(
                  //                     fontFamily: 'Inter',
                  //                     color: Colors.grey[800]),
                  //               ),
                  //             ),
                  //             Spacer(),
                  //             IconButton(
                  //               onPressed: () {},
                  //               icon: FaIcon(
                  //                 FontAwesomeIcons.pen,
                  //                 size: 15,
                  //                 color: Colors.grey,
                  //               ))
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     color: Colors.grey[100],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         width: 100,
                  //         padding: EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(10)),
                  //           color: Colors.green,
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             'Available',
                  //             style: TextStyle(
                  //                 fontFamily: 'Inter',
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 12,
                  //                 color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Row(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(12.0),
                  //               child: Text(
                  //                 '12:00:00',
                  //                 style: TextStyle(
                  //                     fontFamily: 'Inter',
                  //                     color: Colors.grey[800]),
                  //               ),
                  //             ),
                  //             Spacer(),
                  //             IconButton(
                  //                 onPressed: () {},
                  //                 icon: FaIcon(
                  //                   FontAwesomeIcons.pen,
                  //                   size: 15,
                  //                   color: Colors.grey,
                  //                 ))
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: CustomEleButton(
                        text: 'Generate',
                        onPressed: _createTimeSlot,
                        bgColor: Color.fromRGBO(24, 52, 92, 1),
                        fgColor: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekButtons extends StatefulWidget {
  final Function(String) onDateSelected;
  final Function(String) onGetTimeSlot;

  const WeekButtons({
    super.key,
    required this.onDateSelected,
    required this.onGetTimeSlot,
  });

  @override
  WeekButtonsState createState() => WeekButtonsState();
}

class WeekButtonsState extends State<WeekButtons> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    DateTime firstDate = DateTime.now(); // Today
    selectedDate = DateFormat('yyyy-MM-dd').format(firstDate);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates =
        List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: weekDates.map((date) {
          String dayMonthYearLabel = DateFormat('d MMMM yyyy').format(date);
          String dayNameLabel = DateFormat('EEEE').format(date);
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          bool isSelected = formattedDate == selectedDate;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SizedBox(
              width: 165,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: isSelected
                          ? Color.fromRGBO(24, 52, 92, 1)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = formattedDate;
                  });
                  widget.onDateSelected(formattedDate); // Notify parent
                  widget.onGetTimeSlot(formattedDate); // Call to get time slot
                  print('Selected date: $formattedDate');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dayNameLabel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey[800],
                        )),
                    Text(
                      dayMonthYearLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
