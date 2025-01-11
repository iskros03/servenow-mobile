import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';

class BookingDetails extends StatefulWidget {
  final dynamic bookingId;

  const BookingDetails({super.key, this.bookingId});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool isLoading = false;
  Map<String, dynamic>? bookingDetails;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final taskerBooking = TaskerBooking();
      final response = await taskerBooking.getTaskerBookingDetails();

      if (response['statusCode'] == 200) {
        final bookings = response['booking'] as List<dynamic>;
        setState(() {
          bookingDetails = bookings.firstWhere(
            (booking) => booking['id'] == widget.bookingId,
            orElse: () => null,
          );
        });
      } else {
        _showErrorSnackbar('Failed to load bookings.');
      }
    } catch (e) {
      _showErrorSnackbar('Error loading bookings: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: isLoading
          ? Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[800],
                ),
              ),
            )
          : bookingDetails == null
              ? Center(
                  child: Text(
                    'No booking details found.',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[800],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Theme(
                          data: ThemeData(
                            highlightColor: Colors.grey[300],
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: Radius.circular(8.0),
                            thickness: 5.0,
                            child: ListView(
                              children: [
                                _buildDetailCard(
                                    'Task', bookingDetails!['task']),
                                _buildDetailCard('Client Name',
                                    bookingDetails!['client_name']),
                                _buildDetailCard('Phone No',
                                    bookingDetails!['client_phoneno']),
                                _buildTimeRow(
                                  bookingDetails!['date'],
                                  bookingDetails!['startTime'],
                                  bookingDetails!['endTime'],
                                ),
                                _buildDetailCard(
                                    'Address', bookingDetails!['address']),
                                _buildDetailCard(
                                  'Task Note',
                                  bookingDetails!['booking_note'] ??
                                      'No Task Note',
                                ),
                                _buildDetailCard(
                                    'Status',
                                    getBookingStatus(
                                        bookingDetails!['status'])['text']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomEleButton(
                                text: 'Unable To Serve',
                                onPressed: () {},
                                bgColor: Colors.red[50],
                                borderWidth: 0,
                                borderColor: Colors.white,
                                fgColor: Colors.red),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomEleButton(
                                text: 'Confirm Booking',
                                onPressed: () {},
                                bgColor: Colors.green[50],
                                borderWidth: 0,
                                borderColor: Colors.white,
                                fgColor: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDetailCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal,
                color: Colors.grey[800],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.grey.shade300),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String date, String startTime, String endTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Start Time',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[800],
                  ),
                )),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                  'End Time',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[800],
                  ),
                )),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(child: _buildTimeCard(date, startTime)),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeCard(date, endTime)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String date, String time) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat outputFormat = DateFormat('h:mm a');
    DateTime parsedTime = inputFormat.parse(time);
    String formattedTime = outputFormat.format(parsedTime);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade300),
      ),
      child: Text(
        '$date, $formattedTime',
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.normal,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
