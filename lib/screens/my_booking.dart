import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/screens/booking_details.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';

class MyBooking extends StatefulWidget {
  final bool showLeadingIcon;

  const MyBooking({super.key, this.showLeadingIcon = true});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  bool isLoading = true; // Track loading state

  bool preventLoading = false; // Track loading state

  late EventDataSource _dataSource;

  final List<String> viewType = ['Day', 'Month', 'List'];
  String? viewTypeTitle;

  List<Appointment> _appointments = [];
  late CalendarController _calendarController;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<dynamic> filteredBookingList = [];
  List<dynamic> filteredUnavailableSlotList = [];

  List<dynamic> bookingsList = [];

  List<dynamic> unavailableSlotList = [];

  DateTime minDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  DateTime maxDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);

  @override
  void initState() {
    super.initState();
    _dataSource = _getCalendarDataSource();
    _calendarController = CalendarController();
    _loadBookings();
    _loadUnavailableSlot();

    minDate = minDate.add(Duration(hours: 5));
    maxDate = maxDate.add(Duration(hours: 21));
    viewTypeTitle = 'Day';
  }

  Future<void> _loadUnavailableSlot() async {
    setState(() {
      isLoading = true; // Set loading to true before fetching data
    });
    try {
      final taskerBooking = TaskerBooking();
      final bookingResponse = await taskerBooking.getUnavailableSlot();
      setState(() {
        if (bookingResponse['statusCode'] == 200) {
          unavailableSlotList = bookingResponse['data'];

          filteredUnavailableSlotList = unavailableSlotList.where((slot) {
            return slot['date'] == selectedDate;
          }).toList();
          _dataSource = _getCalendarDataSource();
        } else {
          print('Failed to load unavailable slots');
        }
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    }
  }

  Future<void> _loadBookings() async {
    preventLoading == false
        ? setState(() {
            isLoading = false;
          })
        : setState(() {
            isLoading = true;
          });
    try {
      final taskerBooking = TaskerBooking();
      final bookingResponse = await taskerBooking.getTaskerBookingDetails();

      setState(() {
        if (bookingResponse['statusCode'] == 200) {
          bookingsList = bookingResponse['booking'];

          filteredBookingList = bookingsList.where((booking) {
            return booking['date'] == selectedDate;
          }).toList();
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
      print("Error loading bookings: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    }
  }

  int? updateId;
  String? updatedDate;
  String? updateStartTime;
  String? updateEndTime;

  Future<void> _updateBooking() async {
    final updateBookingData = {
      'id': updateId,
      'date': updatedDate,
      'start': updateStartTime,
      'end': updateEndTime,
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
    Colors.red.shade300,
    Colors.indigo.shade300,
    Colors.blue.shade300,
    Colors.purple.shade300,
    Colors.cyan.shade300,
    Colors.teal.shade300,
    Colors.brown.shade300,
    Colors.lime.shade300,
    Colors.orange.shade300,
    Colors.pink.shade300,
    Colors.lightGreen.shade300,
    Colors.blueGrey.shade300,
  ];

  void _showConfirmRescheduleBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Reschedule Confirmation',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Are you sure you want to reschedule this booking? This action may notify the customer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _loadBookings();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).copyWith(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                          surfaceTintColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            preventLoading = false;
                            _updateBooking();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).copyWith(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                          surfaceTintColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        title: const Text(
          'Bookings',
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/booking_summary');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation:
                          2, // Adjust this value to control shadow intensity
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      shadowColor: Colors.grey
                          .withOpacity(0.5), // Shadow color and transparency
                    ).copyWith(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Booking Summary',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600),
                        ),
                        SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.solidEye,
                          color: Colors.blue,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/refund_booking_summary');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation:
                          2, // Adjust this value to control shadow intensity
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      shadowColor: Colors.grey
                          .withOpacity(0.5), // Shadow color and transparency
                    ).copyWith(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Refund Summary',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 10),
                        FaIcon(
                          FontAwesomeIcons.solidEye,
                          color: Colors.blue,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomDropdownMenu(
              items: viewType,
              titleSelect: 'Select View Type',
              titleValue: viewTypeTitle,
              onSelected: (selectedValue) {
                setState(() {
                  viewTypeTitle = selectedValue;
                  _calendarController.view = _getCalendarView(viewTypeTitle);
                  if (viewTypeTitle == 'Day') {
                    selectedDate =
                        DateFormat('yyyy-MM-dd').format(DateTime.now());

                    DateTime selectedDateTime =
                        DateTime.parse(selectedDate.toString());

                    minDate = DateTime(selectedDateTime.year,
                        selectedDateTime.month, selectedDateTime.day, 5, 0, 0);
                    maxDate = DateTime(selectedDateTime.year,
                        selectedDateTime.month, selectedDateTime.day, 21, 0, 0);
                    _loadBookings();
                    _loadUnavailableSlot();
                  } else {
                    minDate = DateTime(2025, 1, 1);
                    maxDate = DateTime(2025, 12, 32);
                  }
                });
              },
            ),
            SizedBox(height: 10),
            if (viewTypeTitle == 'Day')
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

                    _loadBookings();
                    _loadUnavailableSlot();
                  });
                },
              ),
            isLoading // Check if loading
                ? Expanded(
                    child: Center(
                        child: Text(
                      'Loading...',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ) // Show loading indicator
                        ),
                  )
                : viewTypeTitle == 'Day' &&
                        (filteredBookingList.isNotEmpty &&
                            unavailableSlotList.isNotEmpty)
                    ? Column(
                        children: [
                          filteredBookingList.isNotEmpty
                              ? SizedBox(height: 10)
                              : SizedBox.shrink(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: (filteredBookingList).map((booking) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: SizedBox(
                                    width: 350,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookingDetails(
                                              bookingId: booking['id'],
                                              bookingTask: booking['task'],
                                              bookingStatus: booking['status'],
                                              bookingClientName:
                                                  booking['client_name'],
                                              bookingCLientPhone:
                                                  booking['client_phoneno'],
                                              bookingClientAddress:
                                                  booking['address'],
                                              bookingDate: booking['date'],
                                              bookingStartTime:
                                                  booking['startTime'],
                                              bookingEndTime:
                                                  booking['endTime'],
                                              bookingRate:
                                                  booking['booking_rate'],
                                              bookingLat: booking['lat'],
                                              bookingLong: booking['long'],
                                              bookingNote:
                                                  booking['booking_note'] ??
                                                      'Unavailable Note.',
                                            ),
                                          ),
                                        ).then((result) {
                                          if (result == true) {
                                            _loadBookings();
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                      ).copyWith(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        shadowColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        surfaceTintColor:
                                            WidgetStateProperty.all(
                                                Colors.transparent),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              booking['status'] == 3 ||
                                                      booking['status'] == 6
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          booking['status'] == 3
                                                              ? 'Confirmed'
                                                              : booking['status'] ==
                                                                      6
                                                                  ? 'Completed '
                                                                  : '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Inter'),
                                                        ),
                                                        SizedBox(width: 10),
                                                      ],
                                                    )
                                                  : SizedBox.shrink(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: booking['status'] ==
                                                                3 ||
                                                            booking['status'] ==
                                                                6
                                                        ? Colors.grey.shade50
                                                        : booking['color'],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Text(
                                                  booking['title'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      color: booking['status'] ==
                                                                  3 ||
                                                              booking['status'] ==
                                                                  6
                                                          ? Colors.grey.shade500
                                                          : Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${booking['address']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.475,
                            child: SfCalendar(
                              controller: _calendarController,
                              view: _getCalendarView(viewTypeTitle),
                              selectionDecoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              minDate: minDate,
                              maxDate: maxDate,
                              dataSource: _dataSource,
                              appointmentBuilder: appointmentBuilder,
                              timeSlotViewSettings: const TimeSlotViewSettings(
                                startHour: 7,
                                endHour: 20,
                                timeFormat: 'HH:00',
                                timeIntervalHeight: 30,
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
                              viewHeaderHeight: 0,
                              headerStyle: CalendarHeaderStyle(
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              headerHeight: 0,
                              onDragEnd: dragEnd,
                            ),
                          ),
                        ],
                      )
                    : viewTypeTitle == 'Month' || viewTypeTitle == 'List'
                        ? Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: (bookingsList).map((booking) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: SizedBox(
                                        width: 350,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BookingDetails(
                                                  bookingId: booking['id'],
                                                  bookingTask: booking['task'],
                                                  bookingStatus:
                                                      booking['status'],
                                                  bookingClientName:
                                                      booking['client_name'],
                                                  bookingCLientPhone:
                                                      booking['client_phoneno'],
                                                  bookingClientAddress:
                                                      booking['address'],
                                                  bookingLat: booking['lat'],
                                                  bookingLong: booking['long'],
                                                  bookingDate: booking['date'],
                                                  bookingStartTime:
                                                      booking['startTime'],
                                                  bookingEndTime:
                                                      booking['endTime'],
                                                  bookingNote:
                                                      booking['booking_note'] ??
                                                          'No Task Note.',
                                                ),
                                              ),
                                            ).then((result) {
                                              if (result == true) {
                                                _loadBookings();
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                          ).copyWith(
                                            overlayColor:
                                                WidgetStateProperty.all(
                                                    Colors.transparent),
                                            shadowColor:
                                                WidgetStateProperty.all(
                                                    Colors.transparent),
                                            surfaceTintColor:
                                                WidgetStateProperty.all(
                                                    Colors.transparent),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  booking['status'] == 3 ||
                                                          booking['status'] == 6
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              booking['status'] ==
                                                                      3
                                                                  ? 'Confirmed'
                                                                  : booking['status'] ==
                                                                          6
                                                                      ? 'Completed '
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Inter'),
                                                            ),
                                                            SizedBox(width: 10),
                                                          ],
                                                        )
                                                      : SizedBox.shrink(),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color: booking['status'] ==
                                                                    3 ||
                                                                booking['status'] ==
                                                                    6
                                                            ? Colors
                                                                .grey.shade50
                                                            : booking['color'],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Text(
                                                      booking['title'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          fontFamily: 'Inter',
                                                          color: booking['status'] ==
                                                                      3 ||
                                                                  booking['status'] ==
                                                                      6
                                                              ? Colors
                                                                  .grey.shade500
                                                              : Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${booking['address']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                child: SfCalendar(
                                  controller: _calendarController,
                                  view: _getCalendarView(viewTypeTitle),
                                  selectionDecoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  minDate: minDate,
                                  maxDate: maxDate,
                                  dataSource: _dataSource,
                                  appointmentBuilder: appointmentBuilder,
                                  timeSlotViewSettings:
                                      const TimeSlotViewSettings(
                                    startHour: 7,
                                    endHour: 20,
                                    timeFormat: 'HH:00',
                                    timeIntervalHeight: 32.5,
                                  ),
                                  allowDragAndDrop: true,
                                  dragAndDropSettings:
                                      const DragAndDropSettings(
                                    indicatorTimeFormat: 'HH:00',
                                    showTimeIndicator: false,
                                    allowScroll: false,
                                  ),
                                  backgroundColor: Colors.white,
                                  showWeekNumber: false,
                                  showCurrentTimeIndicator: false,
                                  viewHeaderHeight: 0,
                                  headerStyle: CalendarHeaderStyle(
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // headerHeight: 0,
                                  onDragEnd: dragEnd,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: Center(
                              child: Text(
                                "You have no bookings yet.",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
          ],
        ),
      ),
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;

    String showStartTime = DateFormat('HH:mm').format(appointment.startTime);
    String showEndTime = DateFormat('HH:mm').format(appointment.endTime);

    return Container(
      decoration: BoxDecoration(
        color: appointment.recurrenceId == 3 || appointment.recurrenceId == 6
            ? Colors.grey[50]
            : appointment.color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          appointment.recurrenceId == 3 || appointment.recurrenceId == 6
              ? Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: Text(
                        appointment.recurrenceId == 3
                            ? 'Confirmed'
                            : appointment.recurrenceId == 6
                                ? 'Completed'
                                : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                )
              : SizedBox.shrink(),
          Text(
            appointment.subject,
            style: TextStyle(
              color: appointment.subject == 'Unavailable Slot'
                  ? Colors.red
                  : appointment.recurrenceId == 3 ||
                          appointment.recurrenceId == 6
                      ? Colors.grey[500]
                      : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          Spacer(),
          Text(
            '$showStartTime - $showEndTime',
            style: TextStyle(
              color: appointment.subject == 'Unavailable Slot'
                  ? Colors.red
                  : appointment.recurrenceId == 3 ||
                          appointment.recurrenceId == 6
                      ? Colors.grey[500]
                      : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
        ],
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
        subject: book['title'],
        color: bookingColor,
        id: book['id'],
        recurrenceId: book['status'],
      ));
    }

    for (var slot in unavailableSlotList) {
      appointments.add(Appointment(
        startTime: DateTime.parse('${slot['date']} ${slot['startTime']}'),
        endTime: DateTime.parse('${slot['date']} ${slot['endTime']}'),
        subject: slot['title'] + ' Slot',
        color: Colors.red.shade50,
        id: slot['slot_id'],
        recurrenceId: slot['slot_status'],
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

    if (appointment.recurrenceId == 0) {
      setState(() {
        _revertUnavailable(appointment, revert: true);
      });
    } else if (appointment.recurrenceId == 3 || appointment.recurrenceId == 6) {
      setState(() {
        _revertBookingTimes(appointment, revert: true);
      });
    } else if (_hasConflict(roundedStartTime, roundedEndTime, appointment)) {
      setState(() {
        _revertBookingTimes(appointment, revert: true);
      });
    } else {
      setState(() {
        _updateBookingTimes(appointment, roundedStartTime, roundedEndTime);
        updateId = appointment.id;
        DateTime startTime = appointment.startTime;
        updatedDate =
            "${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}";
        updateStartTime = appointment.startTime.toString().substring(11, 19);
        updateEndTime = appointment.endTime.toString().substring(11, 19);
        _showConfirmRescheduleBookingDialog();
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
                    borderRadius: BorderRadius.circular(7.5),
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
                        color: Colors.grey[700],
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
