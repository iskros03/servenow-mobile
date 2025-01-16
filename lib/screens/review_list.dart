import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewList extends StatefulWidget {
  final List<dynamic>? reviewData;
  final List<dynamic>? reviewReplyData;

  const ReviewList({super.key, this.reviewData, this.reviewReplyData});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  List<dynamic> reviewData = [];
  List<dynamic> reviewReplyData = [];

  @override
  void initState() {
    super.initState();
    reviewData = widget.reviewData ?? [];
    reviewReplyData = widget.reviewReplyData ?? [];
    print(reviewData);
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
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(7.5)),
                      ),
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
                                      color: Colors.grey[800]),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2.5),
                                child: Text(
                                    getReviewStatus(
                                        review['review_status'])['text'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
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
                                      index < int.parse(review['review_rating'])  ? Colors.orange : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '16 January 2025 2:16 AM',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[800]),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300)),
                            child: Row(
                              children: [
                                Text(
                                  'Isk Ros: ',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                ),
                                Text(
                                  review['review_description'],
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Spacer(),
                              Container(
                                width: 35,
                                height: 35, // Ensure the container is a circle
                                decoration: BoxDecoration(
                                  color: Colors.blue[50], // Background color
                                  shape: BoxShape
                                      .circle, // Makes the background circular
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/review_management');
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
