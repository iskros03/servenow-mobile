import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
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

  List<String> states = [];
  List<String> areas = [];
  final List<String> workingType = [
    'Full Time',
    'Part Time',
  ];

  String? workingLocState;
  String? workingLocArea;

  String? selectedWorkingType;

  @override
  void initState() {
    super.initState();
    taskerDataFuture = _loadTaskerData();
    fetchStateNames();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  SizedBox(height: 15),
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
                                'Choose your working type',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                'Full time - (7:30 AM to 7:30 PM), Part time - (2:30 PM to 7:30 PM)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                        CustomDropdownMenu(
                          items: workingType,
                          titleSelect: 'Select Working Type',
                          titleValue:
                              selectedWorkingType ?? 'Select Working Type',
                          onSelected: (selectedValue) {
                            setState(() {
                              selectedWorkingType = selectedValue;
                            });
                            fetchAreaNames(selectedValue);
                          },
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
