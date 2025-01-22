import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/screens/update_timeslot_availability.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';

class TaskPreferences extends StatefulWidget {
  final bool showLeadingIcon;

  const TaskPreferences({super.key, this.showLeadingIcon = true});

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
  int workingRadius = 0;
  int? workingStatus;

  int taskerStatus = 0;

  List<Map<String, dynamic>> timeSlots = [];
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchAreaNames(String selectedArea) async {
    TaskerUser getArea = TaskerUser();
    setState(() {
      isLoading = true;
    });
    try {
      final areaNames = await getArea.getArea(selectedArea);
      setState(() {
        areas = areaNames;
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, String>> _loadTaskerData() async {
    TaskerUser taskerUser = TaskerUser();
    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      var data = await taskerUser.getTaskerData();

      workingLocState = data[0]['tasker_workingloc_state'];
      workingLocArea = data[0]['tasker_workingloc_area'];
      selectedWorkingTypeValue = data[0]['tasker_worktype'];
      workingRadius = data[0]['working_radius'];
      workingStatus = data[0]['tasker_working_status'];
      taskerStatus = data[0]['tasker_status'];

      if (workingStatus == 1) {
        isPublic = true;
      } else {
        isPublic = false;
      }

      initialTaskerData = {
        'tasker_workingloc_state': data[0]['tasker_workingloc_state'],
        'tasker_workingloc_area': data[0]['tasker_workingloc_area'],
        'working_radius': data[0]['working_radius'].toString(),
        'tasker_worktype': data[0]['tasker_worktype'].toString(),
      };
      return initialTaskerData;
    } catch (e) {
      return {'Error': '$e'};
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _saveWorkingPreferredLocation() async {
    final updatedLocation = {
      'tasker_workingloc_state': workingLocState,
      'tasker_workingloc_area': workingLocArea,
      'working_radius': workingRadius,
    };

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade200,
          content: Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey.shade800,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          duration: Duration(seconds: 3),
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
                    fontWeight: FontWeight.normal),
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
          content: Center(
            child: Text(
              '$error',
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
          ),
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
                response['data']['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
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
                response['data']['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      SnackBar(
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            'Error $e',
            style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.normal),
          ),
        ),
        duration: Duration(seconds: 3),
      );
    }
  }

  void _changeTaskerVisibility() async {
    try {
      TaskerService taskerService = TaskerService();
      final response = await taskerService.changeTaskerVisibility();

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(
              child: Text(
                response['data']['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
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
                response['data']['message'],
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      SnackBar(
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            'Error $e',
            style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.normal),
          ),
        ),
        duration: Duration(seconds: 3),
      );
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
          content: Center(
            child: Text(
              'Error generating time slots: $e',
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _getTimeSlot(String date) async {
    setState(() {
      isLoading = true;
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
        isLoading = false;
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

  Map<String, dynamic> getTaskerStatus(int taskerStatus) {
    switch (taskerStatus) {
      case 0:
        return {
          'text': 'Incomplete Profile',
          'color': Colors.orange[50],
          'textColor': Colors.orange[500]
        };
      case 1:
        return {
          'text': 'Not Verified',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 2:
        return {
          'text': 'Verified & Active',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 3:
        return {
          'text': 'Inactive',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: widget.showLeadingIcon
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
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
              SizedBox(width: double.infinity, child: Tab(text: 'Time Slot')),
              SizedBox(width: double.infinity, child: Tab(text: 'Preferences')),
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
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
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
                  WeekButtons(
                    initialDate: selectedDate!,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    onGetTimeSlot: _getTimeSlot,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: Text(
                            'Loading...',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.grey[600]),
                          ))
                        : timeSlots.isNotEmpty
                            ? Scrollbar(
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
                                          vertical: 1.5),
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.5)),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: getSlotStatus(
                                                      status)['color'],
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: getSlotStatus(
                                                    status)['color'],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.5),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                getSlotStatus(status)['text'],
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: getSlotStatus(
                                                      status)['textColor'],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 75,
                                              child: Text(
                                                textAlign: TextAlign.end,
                                                formatTime(timeSlot['time'] ??
                                                    '00:00:00'),
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 13,
                                                    color: Colors.grey[800]),
                                              ),
                                            ),
                                            Spacer(),
                                            timeSlot['slot_status'] == 2
                                                ? SizedBox.shrink()
                                                : SizedBox(
                                                    height: 35,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => UpdateTimeslotAvailability(
                                                                      slotStatus:
                                                                          timeSlot[
                                                                              'slot_status'],
                                                                      slotId: timeSlot[
                                                                          'taskerTimeSlotID']))).then(
                                                              (result) {
                                                            if (result ==
                                                                true) {
                                                              print('true');
                                                              _getTimeSlot(
                                                                  selectedDate
                                                                      .toString());
                                                            }
                                                          });
                                                        },
                                                        icon: FaIcon(
                                                          FontAwesomeIcons.pen,
                                                          size: 15,
                                                          color: Colors.grey,
                                                        )),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.grey[100],
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'No time slots available. Please generate.',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                  ),
                  timeSlots.isEmpty
                      ? Column(
                          children: [
                            SizedBox(height: 10),
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
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Acount Status',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: getTaskerStatus(taskerStatus)['color'],
                            borderRadius: BorderRadius.all(Radius.circular(7.5)),
                          ),
                          child: Text(
                            getTaskerStatus(taskerStatus)['text'],
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color:
                                    getTaskerStatus(taskerStatus)['textColor'],
                                fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Profile Visibility',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 50,
                          height: 25,
                          child: Switch(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
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
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(7.5))),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Preferred Working Type',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CustomDropdownMenu(
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(7.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Working Preferred Location',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
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
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
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
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Working Radius (KM)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[800]),
                                ),
                              ),
                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7.5),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade300)),
                                child: Row(
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                          activeTrackColor:
                                              Color.fromRGBO(24, 52, 92, 1),
                                          thumbColor:
                                              Color.fromRGBO(24, 52, 92, 1),
                                          inactiveTrackColor:
                                              Color.fromRGBO(24, 52, 92, 1)
                                                  .withOpacity(0.5),
                                          overlayShape:
                                              SliderComponentShape.noThumb),
                                      child: Expanded(
                                        child: Slider(
                                          value: workingRadius.toDouble(),
                                          min: 0,
                                          max: 100,
                                          label:
                                              workingRadius.round().toString(),
                                          onChanged: (double value) {
                                            setState(() {
                                              workingRadius = value.toInt();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${workingRadius.round()} KM',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              )
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
                      color: isSelected ? Colors.grey.shade300 : Colors.white,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7.5),
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

String formatTime(String time) {
  final dateFormat = DateFormat('hh:mm a');
  final timeFormat = DateFormat('HH:mm:ss'); // Original format (24-hour)
  final parsedTime = timeFormat.parse(time);
  return dateFormat.format(parsedTime);
}
