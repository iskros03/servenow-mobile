import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';

import 'package:url_launcher/url_launcher.dart';

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
  final dynamic bookingRate;
  final dynamic bookingEmail;
  final dynamic bookingLat;
  final dynamic bookingLong;

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
      this.bookingTask,
      this.bookingRate,
      this.bookingEmail,
      this.bookingLat,
      this.bookingLong});

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
  dynamic bookingRate;
  dynamic bookingEmail;
  dynamic bookingLat;
  dynamic bookingLong;

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
    bookingRate = '${widget.bookingRate}';
    bookingEmail = '${widget.bookingEmail}';
    
    bookingLat = '${widget.bookingLat}';
    bookingLong = '${widget.bookingLong}';

    print(bookingLat);
    print(bookingLong);
  }

  Future<void> _changeBookingStatus() async {
    final changeBooking = {'option': option, 'id': bookingId};
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

      final taskerBooking = TaskerBooking();
      final response = await taskerBooking.changeBookingStatus(changeBooking);

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['data']['message'],
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
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

  String formatTime(String time) {
    final dateFormat = DateFormat('hh:mm a');
    final timeFormat = DateFormat('HH:mm:ss'); // Original format (24-hour)
    final parsedTime = timeFormat.parse(time);
    return dateFormat.format(parsedTime);
  }

  void launchWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openWaze(double latitude, double longitude) async {
    final Uri wazeUrl =
        Uri.parse('waze://?ll=$latitude,$longitude&navigate=yes');
    if (await canLaunchUrl(wazeUrl)) {
      await launchUrl(wazeUrl);
    } else {
      // If Waze is not available, try opening it in Google Maps
      final Uri googleMapsUrl =
          Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        throw 'Could not launch the map';
      }
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
      body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
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
                              color: Colors.grey[700],
                              fontSize: 13),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: getBookingStatus(bookingStatus)['color'],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            getBookingStatus(bookingStatus)['text'],
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: getBookingStatus(
                                    bookingStatus)['textColor'],
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    bookingRate == 'null'
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'RM $bookingRate',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[600],
                                    fontSize: 13),
                              ),
                            ],
                          ),
                    SizedBox(height: 5),
                    Text(
                      bookingClientName,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700],
                          fontSize: 13),
                    ),
                    SizedBox(height: 5),
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              formatTime(bookingStartTime),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          formatTime(bookingEndTime),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
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
                                color: Colors.blue[700],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        (bookingStatus == 2 ||
                                bookingStatus == 3 ||
                                bookingStatus == 4 ) && bookingLat != 'null' || bookingLong != 'null'
                            ? Expanded(
                                flex: 1,
                                child: Container(
                                  width: 35,
                                  height:
                                      35, // Ensure the container is a circle
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50], // Background color
                                    shape: BoxShape
                                        .circle, // Makes the background circular
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        openWaze(double.parse(bookingLat) , double.parse(bookingLong));
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.locationArrow,
                                        size: 18,
                                      ),
                                      color: Colors.blue,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    SizedBox(height: 5),
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
                                color: Colors.green[700],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        bookingStatus == 2 ||
                                bookingStatus == 3 ||
                                bookingStatus == 4
                            ? Expanded(
                                flex: 1,
                                child: Container(
                                  width: 35,
                                  height:
                                      35, // Ensure the container is a circle
                                  decoration: BoxDecoration(
                                    color: Colors.green[50], // Background color
                                    shape: BoxShape
                                        .circle, // Makes the background circular
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      launchWhatsApp('$bookingCLientPhone');
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      size: 18,
                                    ),
                                    color: Colors.green,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                ),
                              )
                            : Expanded(flex: 1, child: SizedBox.shrink())
                      ],
                    ),
                    SizedBox(height: 5),
                    bookingRate == 'null'
                        ? SizedBox.shrink()
                        : Text(
                            bookingEmail,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                    bookingStatus == 2 ||
                            bookingStatus == 3 ||
                            bookingStatus == 4 ||
                            bookingStatus == 6
                        ? Column(
                            children: [
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
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
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
              SizedBox(height: 10),
              bookingStatus == 2 || bookingStatus == 4
                  ? Row(
                      children: [
                        SizedBox(width: 10),
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
                        SizedBox(width: 10),
                      ],
                    )
                  : SizedBox.shrink()
            ],
          )),
    );
  }
}
