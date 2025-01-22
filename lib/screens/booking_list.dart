import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/screens/booking_details.dart';

class BookingList extends StatefulWidget {
  final List<dynamic>? bookingData;

  const BookingList({super.key, this.bookingData});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  List<dynamic> services = [];
  List<dynamic> serviceType = [];
  List<dynamic> bookingData = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookingData = widget.bookingData ?? [];
  }

  Map<String, dynamic> getBookingStatus(int status) {
    switch (status) {
      case 1:
        return {
          'text': 'To Pay',
          'color': Colors.orange[50],
          'textColor': Colors.orange[500]
        };
      case 2:
        return {
          'text': 'Paid',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 3:
        return {
          'text': 'Confirmed',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 4:
        return {
          'text': 'Rescheduled',
          'color': Colors.purple[50],
          'textColor': Colors.purple[500]
        };
      case 6:
        return {
          'text': 'Completed',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 7:
        return {
          'text': 'Pending Refund',
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

  String capitalizeFirstLetter(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] =
          words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return words.join(' ');
  }

  String formatTime(String time) {
    final dateFormat = DateFormat('hh:mm a');
    final timeFormat = DateFormat('HH:mm:ss'); // Original format (24-hour)
    final parsedTime = timeFormat.parse(time);
    return dateFormat.format(parsedTime);
  }

  // Future<void> _refresh() async {
  //   setState(() {
  //     bookingData = widget.bookingData ?? [];
  //     print(bookingData);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Booking List',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
        //     onPressed: _refresh,
        //   ),
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            bookingData.isEmpty
                ? Expanded(
                    child: Center(
                    child: Text(
                      'You have no bookings yet.',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700]),
                    ),
                  ))
                : Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: Radius.circular(7.5),
                      thickness: 2.5,
                      child: ListView.builder(
                        itemCount: bookingData.length,
                        itemBuilder: (context, index) {
                          final booking = bookingData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              ).copyWith(
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                shadowColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                surfaceTintColor:
                                    WidgetStateProperty.all(Colors.transparent),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingDetails(
                                      bookingId: booking['bookingID'],
                                      bookingTask: booking['servicetype_name'],
                                      bookingEmail: booking['client_email'],
                                      bookingStatus: booking['booking_status'],
                                      bookingClientName:
                                          booking['client_firstname'] +
                                              ' ' +
                                              booking['client_lastname'],
                                      bookingCLientPhone:
                                          booking['client_phoneno'],
                                      bookingClientAddress:
                                          booking['booking_address'],
                                      bookingDate: booking['booking_date'],
                                      bookingStartTime:
                                          booking['booking_time_start'],
                                      bookingEndTime:
                                          booking['booking_time_end'],
                                      bookingRate: booking['booking_rate'],
                                      bookingLat: booking['lat'],
                                      bookingLong: booking['long'],
                                      bookingNote: booking['booking_note'] ??
                                          'Unavailable Note.',
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                            color: Colors.grey[50]),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          booking['booking_order_id'],
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey.shade600),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(7.5)),
                                          color: getBookingStatus(
                                                  booking['booking_status'])[
                                              'color'],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 2.5),
                                        child: Text(
                                            getBookingStatus(
                                                    booking['booking_status'])[
                                                'text'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: getBookingStatus(booking[
                                                      'booking_status'])[
                                                  'textColor'],
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 75,
                                          child: Text(
                                            "RM ${booking['booking_rate']}",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange[700]),
                                          ),
                                        ),
                                        Text(
                                          booking['servicetype_name'],
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          DateFormat('d MMMM yyyy').format(
                                              DateTime.parse(
                                                  booking['booking_date'])),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${formatTime(booking['booking_time_start'])} - ${formatTime(booking['booking_time_end'])}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[800],
                                          ),
                                        ),
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
          ],
        ),
      ),
    );
  }
}
