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

  bool isPublic = true;

  String? selectedDate;

  List<String> states = [];
  List<String> areas = [];

  String? workingLocState;
  String? workingLocArea;

  String? selectedWorkingType;
  int? selectedWorkingTypeValue;

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
        selectedDate = date;
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
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
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
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]),
                              ),
                            ],
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
                              selectedWorkingType = selectedValue;
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
                    initialDate: selectedDate!,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    onGetTimeSlot: _getTimeSlot,
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time Slot',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.grey[800]),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Available',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.grey[800]),
                          ),
                          SizedBox(width: 16),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Unavailable',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.grey[800]),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 5),
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
                                  Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      itemCount: timeSlots.length,
                                      itemBuilder: (context, index) {
                                        final timeSlot = timeSlots[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.grey[100],
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 15),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: timeSlot[
                                                                  'slot_status'] ==
                                                              1
                                                          ? Colors.green
                                                          : Colors.red),
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
                                                      IconButton(
                                                          onPressed: () {},
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .pen,
                                                            size: 15,
                                                            color: Colors.grey,
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
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.grey.shade50.withOpacity(0),
                                            Colors.grey.shade50.withOpacity(1),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
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
                  SizedBox(height: 15),
                  timeSlots.isEmpty
                      ? SizedBox(
                          width: double.infinity,
                          child: CustomEleButton(
                            text: 'Generate',
                            onPressed: () {
                              _createTimeSlot();
                            },
                            bgColor: Color.fromRGBO(24, 52, 92, 1),
                            fgColor: Colors.white,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 45),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  SizedBox(height: 25),
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
                              });
                            },
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.grey,
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Visibility(
                    visible: isPublic,
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
                        const SizedBox(height: 5),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'State',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
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
                        SizedBox(height: 15),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Area',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
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
