import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  late EventDataSource _dataSource;

  final List<String> viewType = ['Day', 'Month', 'List'];
  String? viewTypeTitle;

  List<Appointment> _appointments = [];
  late CalendarController _calendarController;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<dynamic> bookingsList = [];
  bool isLoadingBookingList = false;

  List<dynamic> unavailableSlotList = [];

  DateTime minDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  DateTime maxDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _loadBookings();
    _loadUnavailableSlot();

    minDate = minDate.add(Duration(hours: 5));
    maxDate = maxDate.add(Duration(hours: 21));
  }

  Future<void> _loadUnavailableSlot() async {
    try {
      final taskerBooking = TaskerBooking();
      final bookingResponse = await taskerBooking.getUnavailableSlot();
      setState(() {
        if (bookingResponse['statusCode'] == 200) {
          unavailableSlotList = bookingResponse['data'];
          _dataSource = _getCalendarDataSource();
        } else {
          print('Failed to load unavailable slots');
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _loadBookings() async {
    try {
      setState(() {
        isLoadingBookingList = true;
      });
      final taskerBooking = TaskerBooking();
      final bookingResponse = await taskerBooking.getTaskerBookingDetails();
      setState(() {
        isLoadingBookingList = false;
        if (bookingResponse['statusCode'] == 200) {
          bookingsList = bookingResponse['booking'];
          // Assign a color from the predefined list for each booking
          for (int i = 0; i < bookingsList.length; i++) {
            bookingsList[i]['color'] =
                predefinedColors[i % predefinedColors.length];
          }
          _dataSource = _getCalendarDataSource();
        } else {
          print('Failed to load bookings');
        }
      });
    } catch (e) {
      setState(() {
        isLoadingBookingList = false;
      });
      print("Error loading bookings: $e");
    }
  }

  int? updateId;
  String? updatedDate;
  String? updateStartTime;
  String? updateEndTime;

  void _updateBooking() async {
    final updateBookingData = {
      'id': updateId,
      'date': updatedDate,
      'start': updateStartTime,
      'end': updateEndTime,
    };
    try {
      TaskerBooking taskerBooking = TaskerBooking();
      final response =
          await taskerBooking.updateBookingSchedule(updateBookingData);

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(response['data']['message'])),
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
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  List<Color> predefinedColors = [
    Colors.brown.shade300,
    Colors.red.shade300,
    Colors.indigo.shade300,
    Colors.blue.shade300,
    Colors.purple.shade300,
    Colors.cyan.shade300,
    Colors.teal.shade300,
    Colors.lime.shade300,
    Colors.orange.shade300,
    Colors.pink.shade300,
    Colors.lightGreen.shade300,
    Colors.blueGrey.shade300,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        title: const Text(
          'My Booking',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildDateSelector(),
            const SizedBox(height: 10),
            WeekButtons(
              initialDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  DateTime selectedDateTime = DateTime.parse(date.toString());

                  minDate = DateTime(selectedDateTime.year,
                      selectedDateTime.month, selectedDateTime.day, 5, 0, 0);
                  maxDate = DateTime(selectedDateTime.year,
                      selectedDateTime.month, selectedDateTime.day, 21, 0, 0);
                  print(minDate);
                  selectedDate = date;
                  DateTime parsedDate =
                      DateFormat('yyyy-MM-dd').parse(selectedDate);

                  _calendarController.displayDate = parsedDate;
                });
              },
            ),
            SizedBox(height: 10),
            isLoadingBookingList
                ? Expanded(
                    child: Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : bookingsList.isNotEmpty || unavailableSlotList.isNotEmpty
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: bookingsList.where((booking) {
                                return booking['date'] == selectedDate;
                              }).map((booking) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    width: 325,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: booking['color'],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Text(
                                            booking['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${booking['address']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: SfCalendar(
                              controller: _calendarController,
                              view: _getCalendarView(viewTypeTitle),
                              minDate: minDate,
                              maxDate: maxDate,
                              dataSource: _dataSource,
                              appointmentBuilder: appointmentBuilder,
                              timeSlotViewSettings: const TimeSlotViewSettings(
                                startHour: 7,
                                endHour: 20,
                                timeFormat: 'HH:00',
                                timeIntervalHeight: 32.5,
                              ),
                              allowDragAndDrop: true,
                              dragAndDropSettings: const DragAndDropSettings(
                                indicatorTimeFormat: 'HH:00',
                                showTimeIndicator: false,
                                allowScroll: false,
                              ),
                              backgroundColor: Colors.white,
                              showWeekNumber: false,
                              showCurrentTimeIndicator: false,
                              // viewHeaderHeight: 0,
                              headerHeight: 0,
                              onDragEnd: dragEnd,
                            ),
                          ),
                        ],
                      )
                    : Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No booking on',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                DateFormat('d MMMM yyyy')
                                    .format(DateTime.parse(selectedDate)),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;
    return Container(
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(5),
      child: Text(
        appointment.subject,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Inter'),
      ),
    );
  }

  EventDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var book in bookingsList) {
      Color bookingColor = book['color'];
      appointments.add(Appointment(
        startTime: DateTime.parse('${book['date']} ${book['startTime']}'),
        endTime: DateTime.parse('${book['date']} ${book['endTime']}'),
        subject: book['task'],
        color: bookingColor,
        id: book['id'],
      ));
    }

    for (var slot in unavailableSlotList) {
      appointments.add(Appointment(
        startTime: DateTime.parse('${slot['date']} ${slot['startTime']}'),
        endTime: DateTime.parse('${slot['date']} ${slot['endTime']}'),
        subject: slot['title'],
        color: Colors.grey.shade200,
        id: slot['slot_id'],
      ));
    }

    _appointments = appointments;
    return EventDataSource(appointments);
  }

  CalendarView _getCalendarView(String? viewType) {
    switch (viewType) {
      case 'Month':
        return CalendarView.month;
      case 'List':
        return CalendarView.schedule;
      default:
        return CalendarView.day;
    }
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment!;

    DateTime roundedStartTime = _roundToNearestHour(appointment.startTime);
    DateTime roundedEndTime = _roundToNearestHour(appointment.endTime);

    if (appointment.subject == 'Unavailable') {
      _revertUnavailable(appointment, revert: true);
    } else if (_hasConflict(roundedStartTime, roundedEndTime, appointment)) {
      setState(() {
        _revertBookingTimes(appointment, revert: true);
      });
    } else {
      setState(() {
        bool hasChanged = appointment.startTime != roundedStartTime || appointment.endTime != roundedEndTime;
        _updateBookingTimes(appointment, roundedStartTime, roundedEndTime);
        print(appointment);
        updateId = appointment.id;
        DateTime startTime = appointment.startTime;
        updatedDate =
            "${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}";
        updateStartTime = appointment.startTime.toString().substring(11, 19);
        updateEndTime = appointment.endTime.toString().substring(11, 19);
        if (hasChanged) {
        _updateBooking();
      }
      });
    }

    _dataSource.notifyListeners(
        CalendarDataSourceAction.reset, _dataSource.appointments!);
  }

  bool _hasConflict(
      DateTime startTime, DateTime endTime, Appointment appointment) {
    for (Appointment existingAppointment in _appointments) {
      if (existingAppointment != appointment) {
        if (_isSameDay(startTime, existingAppointment.startTime)) {
          if (startTime.isBefore(existingAppointment.endTime) &&
              endTime.isAfter(existingAppointment.startTime)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _isSameDay(DateTime newTime, DateTime existingTime) {
    return newTime.year == existingTime.year &&
        newTime.month == existingTime.month &&
        newTime.day == existingTime.day;
  }

  DateTime _roundToNearestHour(DateTime dateTime) {
    int minutes = dateTime.minute;
    int roundedMinute = 0;
    int hour = (minutes >= 30) ? dateTime.hour + 1 : dateTime.hour;

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      hour,
      roundedMinute,
    );
  }

  void _updateBookingTimes(Appointment appointment, DateTime roundedStartTime,
      DateTime roundedEndTime) {
    for (var book in bookingsList) {
      if (book['id'] == appointment.id) {
        appointment.startTime = roundedStartTime;
        appointment.endTime = roundedEndTime;

        book['startTime'] = roundedStartTime.toIso8601String();
        book['endTime'] = roundedEndTime.toIso8601String();
        break;
      }
    }
  }

  void _revertUnavailable(Appointment appointment, {bool revert = false}) {
    print('Revert');

    for (var slot in unavailableSlotList) {
      if (slot['slot_id'] == appointment.id) {
        if (revert) {
          DateTime? parsedStartTime = DateTime.tryParse(slot['startTime']);
          DateTime? parsedEndTime = DateTime.tryParse(slot['endTime']);

          if (parsedStartTime != null && parsedEndTime != null) {
            appointment.startTime = parsedStartTime;
            appointment.endTime = parsedEndTime;
          } else {
            DateTime date = DateTime.parse(slot['date']);
            appointment.startTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(slot['startTime'].split(':')[0]),
              int.parse(slot['startTime'].split(':')[1]),
            );
            appointment.endTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(slot['endTime'].split(':')[0]),
              int.parse(slot['endTime'].split(':')[1]),
            );
          }
        }
        break;
      }
    }
  }

  void _revertBookingTimes(Appointment appointment, {bool revert = false}) {
    for (var book in bookingsList) {
      if (book['id'] == appointment.id) {
        if (revert) {
          DateTime? parsedStartTime = DateTime.tryParse(book['startTime']);
          DateTime? parsedEndTime = DateTime.tryParse(book['endTime']);

          if (parsedStartTime != null && parsedEndTime != null) {
            appointment.startTime = parsedStartTime;
            appointment.endTime = parsedEndTime;
          } else {
            DateTime date = DateTime.parse(book['date']);
            appointment.startTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(book['startTime'].split(':')[0]),
              int.parse(book['startTime'].split(':')[1]),
            );
            appointment.endTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(book['endTime'].split(':')[0]),
              int.parse(book['endTime'].split(':')[1]),
            );
          }
        }
        break;
      }
    }
  }

  Widget _buildDateSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            width: 100,
            child: Text(
              selectedDate,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: CustomDropdownMenu(
              items: viewType,
              titleSelect: 'Select View Type',
              titleValue: viewTypeTitle ?? 'Day',
              onSelected: (selectedValue) {
                setState(() {
                  viewTypeTitle = selectedValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class WeekButtons extends StatefulWidget {
  final Function(String) onDateSelected;
  final String initialDate;

  const WeekButtons({
    super.key,
    required this.onDateSelected,
    required this.initialDate,
  });

  @override
  WeekButtonsState createState() => WeekButtonsState();
}

class WeekButtonsState extends State<WeekButtons> {
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
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
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
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
                  widget.onDateSelected(formattedDate);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dayNameLabel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey[600],
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
