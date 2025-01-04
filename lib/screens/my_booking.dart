import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  late EventDataSource _dataSource;

  // Using a list of maps to store booking data
  List<Map<String, dynamic>> booking = [
    {
      'id': 1,
      'startTime': DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
      'endTime': DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
      'startA': 12,
      'endA': 13,
      'subject': 'Team Meeting',
      'color': Colors.blue,
    },
    {
      'id': 2,
      'startTime': DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 15),
      'endTime': DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
      'startA': 15,
      'endA': 17,
      'subject': 'Project Review',
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _dataSource = _getCalendarDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Booking'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SfCalendar(
          view: CalendarView.day,
          minDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 7, 0, 0),
          maxDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, 20, 0, 0)
              .add(Duration(days: 6)),

          dataSource: _dataSource,
          timeSlotViewSettings: const TimeSlotViewSettings(
            startHour: 7,
            endHour: 20,
            timeFormat: 'HH:00',
          ),
          allowDragAndDrop: true,
          dragAndDropSettings: const DragAndDropSettings(
            indicatorTimeFormat: 'HH:00',
            showTimeIndicator: false,
            allowScroll: true,
          ),
          backgroundColor: Colors.white,
          showWeekNumber: false,
          showCurrentTimeIndicator: false,
          // headerHeight: 0,
          onDragEnd: dragEnd,
        ),
      ),
    );
  }

  EventDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];
    for (var book in booking) {
      appointments.add(Appointment(
        startTime: book['startTime'],
        endTime: book['endTime'],
        subject: book['subject'],
        color: book['color'],
      ));
    }
    return EventDataSource(appointments);
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment!;

    // Round start and end times
    DateTime roundedStartTime = _roundToNearestHour(appointment.startTime);
    DateTime roundedEndTime = _roundToNearestHour(appointment.endTime);

    // Check for conflicts
    if (_hasConflict(roundedStartTime, roundedEndTime, appointment)) {
      // Revert to original appointment times if there's a conflict
      setState(() {
        _revertBookingTimes(appointment, revert: true);
      });
      print('Conflict detected. Appointment reverted.');
    } else {
      setState(() {
        _updateBookingTimes(appointment, roundedStartTime, roundedEndTime);
      });
      // Update appointment times
      debugPrint('Updated Appointment:');
      debugPrint('Start Time: ${appointment.startTime}');
      debugPrint('End Time: ${appointment.endTime}');
    }

    // Notify listeners to refresh the calendar view
    _dataSource.notifyListeners(
        CalendarDataSourceAction.reset, _dataSource.appointments!);
  }

  bool _hasConflict(
      DateTime startTime, DateTime endTime, Appointment appointment) {
    for (Appointment existingAppointment in _dataSource.appointments!) {
      if (existingAppointment != appointment) {
        // Check if the new start or end date is different from the original
        if (_isDifferentDate(startTime, existingAppointment.startTime) ||
            _isDifferentDate(endTime, existingAppointment.endTime)) {
          return true; // Conflict detected due to date change
        }

        // Check time overlap
        if (startTime.isBefore(existingAppointment.endTime) &&
            endTime.isAfter(existingAppointment.startTime)) {
          return true; // Time conflict detected
        }
      }
    }
    return false; // No conflict
  }

  bool _isDifferentDate(DateTime newTime, DateTime existingTime) {
    return newTime.year != existingTime.year ||
        newTime.month != existingTime.month ||
        newTime.day != existingTime.day;
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
    for (var book in booking) {
      if (book['subject'] == appointment.subject) {
        book['startTime'] = roundedStartTime;
        book['endTime'] = roundedEndTime;
        break;
      }
    }
    appointment.startTime = roundedStartTime;
    appointment.endTime = roundedEndTime;
  }

  void _revertBookingTimes(Appointment appointment, {bool revert = false}) {
    for (var book in booking) {
      if (book['subject'] == appointment.subject) {
        if (revert) {
          appointment.startTime = book['startTime'];
          appointment.endTime = book['endTime'];
        }
        break;
      }
    }
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
