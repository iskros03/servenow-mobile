import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/screens/booking_details.dart';
import 'package:servenow_mobile/screens/review_management.dart';
import 'package:servenow_mobile/services/tasker_review.dart';

class ReviewList extends StatefulWidget {
  const ReviewList({
    super.key,
  });

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  List<dynamic> reviewData = [];
  List<dynamic> reviewReply = [];

  @override
  void initState() {
    super.initState();
    _loadTaskerReviewList();
  }

  void _loadTaskerReviewList() async {
    try {
      var response = await TaskerReview().getReviewList();
      setState(() {
        reviewData = response['data'];
        reviewReply = response['reply'];
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  String convertDateTime(String originalDateTime) {
    DateTime dateTime = DateTime.parse(originalDateTime);
    String formattedDateTime =
        DateFormat('d MMMM yyyy hh:mm a').format(dateTime);
    return formattedDateTime;
  }

  Map<String, dynamic> getReviewStatus(dynamic status) {
    switch (status) {
      case 1:
        return {
          'text': 'Show',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 2:
        return {
          'text': 'Hide',
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Review List',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: reviewData.length,
                itemBuilder: (BuildContext context, int index) {
                  final review = reviewData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              bookingId: review['booking_id'],
                              bookingTask: review['servicetype_name'],
                              bookingEmail: review['client_email'],
                              bookingStatus: review['booking_status'],
                              bookingClientName: review['client_firstname'] +
                                  ' ' +
                                  review['client_lastname'],
                              bookingCLientPhone: review['client_phoneno'],
                              bookingClientAddress: review['booking_address'],
                              bookingDate: review['booking_date'],
                              bookingStartTime: review['booking_time_start'],
                              bookingEndTime: review['booking_time_end'],
                              bookingRate: review['booking_rate'],
                              bookingLat: review['booking_latitude'],
                              bookingLong: review['booking_longitude'],
                              bookingNote:
                                  review['booking_note'] ?? 'Unavailable Note.',
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
                                    borderRadius: BorderRadius.circular(7.5),
                                    color: Colors.grey[50]),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  review['booking_order_id'],
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
                                        Radius.circular(5)),
                                    color: getReviewStatus(
                                        review['review_status'])['color']),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2.5),
                                child: Text(
                                    getReviewStatus(
                                        review['review_status'])['text'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: getReviewStatus(
                                                review['review_status'])[
                                            'textColor'])),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: List.generate(
                                5,
                                (index) => FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color:
                                      index < int.parse(review['review_rating'])
                                          ? Colors.orange
                                          : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(7.5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${review['client_firstname']} ${review['client_lastname']}",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      convertDateTime(
                                          review['review_date_time']),
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  review['review_description'],
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Spacer(),
                              IconButton(
                                style: ElevatedButton.styleFrom(
                                  elevation:
                                      2, // Adjust this value to control shadow intensity
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  shadowColor: Colors.grey.withOpacity(
                                      0.5), // Shadow color and transparency
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReviewManagement(
                                        reviewReply: reviewReply
                                            .where((reply) =>
                                                reply['booking_id'] ==
                                                review['bookingID'])
                                            .toList(),
                                        bookingOrderId:
                                            review['booking_order_id'],
                                        bookingId: review['bookingID'],
                                        reviewRating: review['review_rating'],
                                        clientFLName:
                                            '${review['client_firstname']} ${review['client_lastname']}',
                                        reviewDateTime: convertDateTime(
                                            review['review_date_time']),
                                        reviewStatus: review['review_status'],
                                        reviewImageOne:
                                            review['review_imageOne'],
                                        reviewImageTwo:
                                            review['review_imageTwo'],
                                        reviewImageThree:
                                            review['review_imageThree'],
                                        reviewImageFour:
                                            review['review_imageFour'],
                                        reviewDescription:
                                            review['review_description'],
                                        reviewID: review['reviewID'],
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result == true) {
                                      _loadTaskerReviewList();
                                    }
                                  });
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.pen,
                                  size: 15,
                                  color: Colors.blue, // Icon color
                                ),
                                splashColor: Colors
                                    .transparent, // Removes the splash effect
                                highlightColor: Colors
                                    .transparent, // Removes the highlight effect
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
