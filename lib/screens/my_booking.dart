import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Booking'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SfCalendar(
          view: CalendarView.day,
          dataSource: _getCalendarDataSource(),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 7,
            endHour: 19,
            timeFormat: 'HH:00',
          ),
          allowDragAndDrop: true,
          dragAndDropSettings: DragAndDropSettings(
            indicatorTimeFormat: 'HH:00',
            showTimeIndicator: false,
            allowScroll: false,
          ),
          backgroundColor: Colors.white,
          showWeekNumber: false,
          showCurrentTimeIndicator: false,
          headerHeight: 0,
          onDragEnd: dragEnd,
        ),
      ),
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    return EventDataSource([
      Appointment(
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10), // Start at 10:00
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 11), // End at 11:00
        subject: 'Team Meeting',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14), // Start at 14:00
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 15), // End at 15:00
        subject: 'Team Meeting',
        color: Colors.blue,
      ),
    ]);
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    dynamic appointment = appointmentDragEndDetails.appointment!;

    // Round start time to the nearest hour
    DateTime roundedStartTime = _roundToNearestHour(appointment.startTime);
    // Round end time to the nearest hour
    DateTime roundedEndTime = _roundToNearestHour(appointment.endTime);

    // Update the appointment's times
    appointment.startTime = roundedStartTime;
    appointment.endTime = roundedEndTime;

    // Print the new appointment details
    print('Updated Appointment:');
    print('Start Time: ${appointment.startTime}');
    print('End Time: ${appointment.endTime}');
  }

  DateTime _roundToNearestHour(DateTime dateTime) {
    // Round the time to the nearest hour
    int minutes = dateTime.minute;
    int roundedMinute =
        (minutes >= 30) ? 0 : 0; // Reset minutes to 0 (round to next hour)
    int hour = (minutes >= 30) ? dateTime.hour + 1 : dateTime.hour;

    // Return the updated DateTime with the rounded hour
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, hour, roundedMinute);
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
