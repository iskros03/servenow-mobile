import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  late EventDataSource _dataSource;

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
          headerHeight: 0,
          // viewHeaderHeight: 0,
          onDragEnd: dragEnd,
        ),
      ),
    );
  }

  EventDataSource _getCalendarDataSource() {
    return EventDataSource([
      Appointment(
        startTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, 10),
        endTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, 11),
        subject: 'Team Meeting',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, 14),
        endTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, 15),
        subject: 'Project Review',
        color: Colors.green,
      ),
    ]);
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment!;

    // Round start and end times
    DateTime roundedStartTime =
        _dataSource.roundToNearestHour(appointment.startTime);
    DateTime roundedEndTime =
        _dataSource.roundToNearestHour(appointment.endTime);

    // Update appointment times
    appointment.startTime = roundedStartTime;
    appointment.endTime = roundedEndTime;

    // Notify listeners to refresh the calendar view
    _dataSource.notifyListeners(
        CalendarDataSourceAction.reset, _dataSource.appointments!);

    // Debugging output
    debugPrint('Updated Appointment:');
    debugPrint('Start Time: ${appointment.startTime}');
    debugPrint('End Time: ${appointment.endTime}');
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }

  DateTime roundToNearestHour(DateTime dateTime) {
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
}
