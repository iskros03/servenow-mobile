import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
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

  bool isPublic = false;

  String? selectedDate;

  List<String> states = [];
  List<String> areas = [];

  String? workingLocState;
  String? workingLocArea;
  int? selectedWorkingTypeValue;
  int? workingStatus;

  List<Map<String, dynamic>> timeSlots = [];
  bool isLoadingTimeSlots = false;

  Map<String, int> workingTypeMap = {
    'Full Time': 1,
    'Part Time': 2,
  };

  int _selectedTabIndex = 0;

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

      if (data.isEmpty) {
        throw Exception('No data found');
      }

      workingLocState = data[0]['tasker_workingloc_state'];
      workingLocArea = data[0]['tasker_workingloc_area'];
      selectedWorkingTypeValue = data[0]['tasker_worktype'];

      workingStatus = data[0]['tasker_working_status'];

      if (workingStatus == 1) {
        isPublic = true;
      } else {
        isPublic = false;
      }

      initialTaskerData = {
        'tasker_workingloc_state': data[0]['tasker_workingloc_state'],
        'tasker_workingloc_area': data[0]['tasker_workingloc_area'],
        'tasker_worktype': data[0]['tasker_worktype'].toString(),
      };
      return initialTaskerData;
    } catch (e) {
      print('Error occurred: $e');
      return {'error': 'Failed to load tasker data'};
    }
  }

  void _saveWorkingPreferredLocation() async {
    final updatedLocation = {
      'tasker_workingloc_state': workingLocState,
      'tasker_workingloc_area': workingLocArea,
    };

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[600],
          content: Text(
            'Saving...',
            style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          ),
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
            backgroundColor: Colors.green,
            content: Center(
              child: Text(
                responseData['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(
              child: Text(
                response['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                response['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _changeTaskerVisibility() async {
    try {
      TaskerService taskerService = TaskerService();
      final response = await taskerService.changeTaskerVisibility();

      if (response['statusCode'] == 200) {
        print("Working type updated successfully.");
      } else {
        print("Failed to update working type.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _createTimeSlot() async {
    try {
      TaskerService taskerService = TaskerService();
      final response = await taskerService.createTimeSlot('$selectedDate');

      if (response['statusCode'] == 201) {
        _getTimeSlot(selectedDate!);
      } else {
        throw response['message'];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating time slots: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _getTimeSlot(String date) async {
    setState(() {
      isLoadingTimeSlots = true;
    });

    try {
      TaskerService taskerService = TaskerService();
      final data = await taskerService.getTimeSlot(date);
      setState(() {
        timeSlots = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching time slots: $e')),
      );
    } finally {
      setState(() {
        isLoadingTimeSlots = false;
      });
    }
  }

  Map<String, dynamic> getSlotStatus(int status) {
    switch (status) {
      case 0:
        return {
          'text': 'Unavailable',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 1:
        return {
          'text': 'Available',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 2:
        return {
          'text': 'Booked',
          'color': Colors.orange[50],
          'textColor': Colors.orange[500]
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
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
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            indicatorColor: Colors.orange[300],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Time Slot'),
              Tab(text: 'Visibility & Location'),
            ],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: _selectedTabIndex == 0
                  ? () {}
                  : _saveWorkingPreferredLocation,
              child: _selectedTabIndex == 0
                  ? SizedBox.shrink()
                  : Text(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Preferred Working Type',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Full time - (7:30 AM to 7:30 PM), Part time - (2:30 PM to 7:30 PM)',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600]),
                          ),
                        ),
                        CustomDropdownMenu(
                          items: workingTypeMap.keys.toList(),
                          titleSelect: 'Select Working Type',
                          titleValue: selectedWorkingTypeValue != null
                              ? workingTypeMap.keys.firstWhere(
                                  (key) =>
                                      workingTypeMap[key] ==
                                      selectedWorkingTypeValue,
                                )
                              : 'Select Working Type',
                          onSelected: (selectedValue) {
                            setState(() {
                              selectedWorkingTypeValue =
                                  workingTypeMap[selectedValue];
                            });
                            _saveWorkingType();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Date',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 10),
                  WeekButtons(
                    initialDate: selectedDate!,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    onGetTimeSlot: _getTimeSlot,
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Time Slot',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: isLoadingTimeSlots
                        ? Center(
                            child: Text(
                            'Loading...',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[600]),
                          ))
                        : timeSlots.isNotEmpty
                            ? Stack(
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      highlightColor: Colors.grey[300],
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      radius: Radius.circular(8.0),
                                      thickness: 5.0,
                                      child: ListView.builder(
                                        itemCount: timeSlots.length,
                                        itemBuilder: (context, index) {
                                          final timeSlot = timeSlots[index];
                                          int status = timeSlot['slot_status'];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 12),
                                                  Container(
                                                    width: 125,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: getSlotStatus(
                                                            status)['color'],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: getSlotStatus(
                                                          status)['color'],
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      getSlotStatus(
                                                          status)['text'],
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: getSlotStatus(
                                                                status)[
                                                            'textColor'],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Text(
                                                            '${timeSlot['time'] ?? 'N/A'}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .grey[800]),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        timeSlot['slot_status'] ==
                                                                2
                                                            ? SizedBox.shrink()
                                                            : IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .pen,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .grey,
                                                                ))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   left: 0,
                                  //   right: 0,
                                  //   bottom: 0,
                                  //   child: Container(
                                  //     height: 25,
                                  //     decoration: BoxDecoration(
                                  //       gradient: LinearGradient(
                                  //         colors: [
                                  //           Colors.grey.shade50.withOpacity(0),
                                  //           Colors.grey.shade50.withOpacity(1),
                                  //         ],
                                  //         begin: Alignment.topCenter,
                                  //         end: Alignment.bottomCenter,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.grey[100],
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'No time slots available. Please generate.',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                  ),
                  timeSlots.isEmpty
                      ? Column(
                          children: [
                            SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: CustomEleButton(
                                text: 'Generate',
                                onPressed: () {
                                  _createTimeSlot();
                                },
                                bgColor: Color.fromRGBO(24, 52, 92, 1),
                                fgColor: Colors.white,
                                borderWidth: 2,
                                borderColor: Colors.white,
                              ),
                            ),
                            // SizedBox(height: 50),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Spacer(),
                        Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: isPublic,
                            onChanged: (value) {
                              setState(() {
                                isPublic = value;
                                _changeTaskerVisibility();
                              });
                            },
                            activeColor: Colors.white,
                            inactiveThumbColor: Color.fromRGBO(24, 52, 92, 1),
                            activeTrackColor: Color.fromRGBO(24, 52, 92, 1),
                            inactiveTrackColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Working Preferred Location',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.grey[800]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'State',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Area',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ),
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
  final String initialDate; // New parameter

  const WeekButtons({
    super.key,
    required this.onDateSelected,
    required this.onGetTimeSlot,
    required this.initialDate, // Accept initial date
  });

  @override
  WeekButtonsState createState() => WeekButtonsState();
}

class WeekButtonsState extends State<WeekButtons> {
  late String selectedDate; // Use late initialization

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate; // Set initial date from the parameter
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
                      color: isSelected ? Colors.grey.shade500 : Colors.white,
                      width: 1.5,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 0,
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = formattedDate;
                  });
                  widget.onDateSelected(formattedDate); // Notify parent
                  widget.onGetTimeSlot(formattedDate); // Call to get time slot
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
