import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';

class BookingDetails extends StatefulWidget {
  final dynamic bookingId;
  final dynamic bookingStatus;
  final dynamic bookingClientName;
  final dynamic bookingClientAddress;
  final dynamic bookingCLientPhone;
  final dynamic bookingStartTime;
  final dynamic bookingNote;
  final dynamic bookingEndTime;
  final dynamic bookingDate;
  final dynamic bookingTask;

  const BookingDetails(
      {super.key,
      this.bookingId,
      this.bookingStatus,
      this.bookingClientName,
      this.bookingClientAddress,
      this.bookingCLientPhone,
      this.bookingStartTime,
      this.bookingDate,
      this.bookingEndTime,
      this.bookingNote,
      this.bookingTask});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  Map<String, dynamic>? bookingDetails;
  int? option;
  dynamic bookingId;
  dynamic bookingTask;
  dynamic bookingStatus;
  dynamic bookingClientName;
  dynamic bookingClientAddress;
  dynamic bookingCLientPhone;
  dynamic bookingStartTime;
  dynamic bookingNote;
  dynamic bookingEndTime;
  dynamic bookingDate;

  @override
  void initState() {
    super.initState();
    _initializeBookingDetails();
  }

  void _initializeBookingDetails() {
    bookingId = '${widget.bookingId}';
    bookingTask = '${widget.bookingTask}';
    bookingStatus = int.tryParse('${widget.bookingStatus}') ?? 0;
    bookingClientName = '${widget.bookingClientName}';
    bookingClientAddress = '${widget.bookingClientAddress}';
    bookingCLientPhone = '${widget.bookingCLientPhone}';
    bookingStartTime = '${widget.bookingStartTime}';
    bookingDate = widget.bookingDate;
    bookingEndTime = '${widget.bookingEndTime}';
    bookingNote = '${widget.bookingNote}';
  }

  Future<void> _changeBookingStatus() async {
    final changeBooking = {'option': option, 'id': bookingId};
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[600],
          content: Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      final taskerBooking = TaskerBooking();
      final response = await taskerBooking.changeBookingStatus(changeBooking);

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['data']['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        if (option == 1) {
          setState(() {
            bookingStatus = option == 1 ? 3 : 0;
          });
        } else if (option == 2) {
          Navigator.pop(context, true);
        }
      } else {
        _showErrorSnackbar('Failed to change booking status.');
      }
    } catch (e) {
      _showErrorSnackbar('Error change booking status: $e');
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
      case 6:
        return {
          'text': 'Completed',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
    }
  }

  void _showChangeStatusBookingConfirmation() {
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
                  'Booking Confirmation',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This action cannot be undone. Are you sure you want to change the status of this booking?',
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
                          _changeBookingStatus();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              option == 1 ? Colors.green[50] : Colors.red[50],
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
                          option == 1 ? 'Confirm' : 'Unable',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: option == 1 ? Colors.green : Colors.red),
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
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              bookingTask,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontSize: 14),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: getBookingStatus(bookingStatus)['color'],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                getBookingStatus(bookingStatus)['text'],
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: getBookingStatus(
                                        bookingStatus)['textColor'],
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          bookingClientName,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
                              fontSize: 13),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Text(
                                  bookingClientAddress,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              flex: 4,
                              child: TextButton.icon(
                                onPressed: () {
                                  print('Get Direction button pressed');
                                },
                                icon: Icon(
                                  FontAwesomeIcons
                                      .locationArrow, // Updated icon
                                ),
                                label: Text(
                                  'Get Direction', // Updated label
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: Colors.blue, width: 1),
                                  ),
                                  textStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  surfaceTintColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Text(
                                  bookingCLientPhone,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              flex: 4,
                              child: TextButton.icon(
                                onPressed: () {
                                  print('Contact button pressed');
                                },
                                icon: Icon(
                                  FontAwesomeIcons.whatsapp,
                                ),
                                label: Text(
                                  'Contact Client',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: Colors.green, width: 1),
                                  ),
                                  textStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  surfaceTintColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1.5,
                              height: 25,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('d MMMM yyyy')
                              .format(DateTime.parse(bookingDate)),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildTimeCard(bookingStartTime),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              child: _buildTimeCard(bookingEndTime),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade50,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.thumbtack,
                                size: 14,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  bookingNote,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  bookingStatus == 2 || bookingStatus == 4
                      ? Row(
                          children: [
                            Expanded(
                              child: CustomEleButton(
                                  text: 'Unable To Serve',
                                  onPressed: () {
                                    setState(() {
                                      option = 2;
                                    });
                                    _showChangeStatusBookingConfirmation();
                                  },
                                  bgColor: Colors.red[50],
                                  borderWidth: 0,
                                  borderColor: Colors.white,
                                  fgColor: Colors.red),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: CustomEleButton(
                                  text: 'Confirm Booking',
                                  onPressed: () {
                                    setState(() {
                                      option = 1;
                                    });
                                    _showChangeStatusBookingConfirmation();
                                  },
                                  bgColor: Colors.green[50],
                                  borderWidth: 0,
                                  borderColor: Colors.white,
                                  fgColor: Colors.green),
                            ),
                          ],
                        )
                      : SizedBox.shrink()
                ],
              )),
        ],
      ),
    );
  }
}

Widget _buildTimeCard(String time) {
  String formattedTime;

  if (time.contains('T')) {
    DateTime parsedTime = DateTime.parse(time);
    formattedTime = DateFormat('h:mm a').format(parsedTime);
  } else {
    try {
      DateFormat inputFormat = DateFormat('HH:mm:ss');
      DateTime parsedTime = inputFormat.parse(time);
      formattedTime = DateFormat('h:mm a').format(parsedTime);
    } catch (e) {
      formattedTime = 'Invalid time';
    }
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Center(
      child: Text(
        formattedTime,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.normal,
          color: Colors.grey[600],
        ),
      ),
    ),
  );
}
