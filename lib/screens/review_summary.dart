import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/screens/review_list.dart';
import 'package:servenow_mobile/services/tasker_review.dart';

class ReviewSummary extends StatefulWidget {
  const ReviewSummary({super.key});

  @override
  State<ReviewSummary> createState() => _ReviewSummaryState();
}

class _ReviewSummaryState extends State<ReviewSummary> {
  List<dynamic> data = [];

  dynamic rating5Count = 0;
  dynamic rating4Count = 0;
  dynamic rating3Count = 0;
  dynamic rating2Count = 0;
  dynamic rating1Count = 0;
  dynamic totalreviewsbymonth = 0;
  dynamic totalreviewsbyyear = 0;
  dynamic totalunreview = 0;
  dynamic averageRating = 0.0;
  dynamic csat = 0.0;
  dynamic negrev = 0.0;
  dynamic neutralrev = 0.0;

  Future<void> _loadTaskerReviewList() async {
    try {
      var response = await TaskerReview().getReviewList();
      if (response['statusCode'] == 200) {
        setState(() {
          data = response['data'];
          rating5Count = response['rating5Count'] ?? 0;
          rating4Count = response['rating4Count'] ?? 0;
          rating3Count = response['rating3Count'] ?? 0;
          rating2Count = response['rating2Count'] ?? 0;
          rating1Count = response['rating1Count'] ?? 0;
          totalreviewsbymonth = response['totalreviewsbymonth'] ?? 0;
          totalreviewsbyyear = response['totalreviewsbyyear'] ?? 0;
          totalunreview = response['totalunreview'] ?? 0;
          averageRating = response['averageRating'] ?? 0.0;
          csat = response['csat'] ?? '';
          negrev = response['negrev'] ?? '';
          neutralrev = response['neutralrev'] ?? '';


        });
      } else {
        print('Failed to load booking list: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    _loadTaskerReviewList();
    super.initState();
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
            'Review Summary',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Reviews',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade700),
                          ),
                          Text(
                            data.length.toString(),
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewList(),
                            ),
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.eye),
                        color: Colors.blue,
                        style: IconButton.styleFrom().copyWith(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                          surfaceTintColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Reviews',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '(January)',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '$totalreviewsbymonth',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Reviews',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '(2025)',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '$totalreviewsbyyear',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Unreview Booking',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '$totalunreview',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade600),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: SizedBox.shrink())
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Average Rating',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '${averageRating.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            )
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Positive Reviews',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '$csat%',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade600,
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Neutral Reviews',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '$neutralrev%',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            )
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Negative Reviews',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '$negrev%',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600,
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidFaceLaughBeam,
                            size: 20,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Very Happy',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.green),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '$rating5Count',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidFaceSmile,
                            size: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Happy',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '$rating4Count',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidFaceMeh,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Neutral',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '$rating3Count',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidFaceFrown,
                            size: 20,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Sad',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.orange),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '$rating2Count',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidFaceAngry,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Angry',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.red),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '$rating1Count',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
