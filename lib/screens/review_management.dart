import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/services/tasker_review.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewManagement extends StatefulWidget {
  final dynamic bookingOrderId;
  final dynamic reviewRating;
  final dynamic clientFLName;
  final dynamic reviewDateTime;
  final dynamic reviewStatus;
  final String? reviewImageOne;
  final String? reviewImageTwo;
  final String? reviewImageThree;
  final String? reviewImageFour;
  final dynamic reviewDescription;
  final dynamic reviewID;
  final dynamic bookingId;
  final List? reviewReply;

  const ReviewManagement(
      {super.key,
      this.bookingOrderId,
      this.reviewRating,
      this.clientFLName,
      this.reviewDateTime,
      this.reviewStatus,
      this.reviewImageOne,
      this.reviewImageTwo,
      this.reviewImageThree,
      this.reviewImageFour,
      this.reviewDescription,
      this.reviewID,
      this.bookingId,
      this.reviewReply});

  @override
  State<ReviewManagement> createState() => _ReviewManagementState();
}

class _ReviewManagementState extends State<ReviewManagement> {
  final TextEditingController replyController = TextEditingController();

  double iconOpacity = 0.3;

  dynamic bookingOrderId;
  dynamic reviewRating;
  dynamic clientFLName;
  dynamic reviewDateTime;
  dynamic reviewStatus;
  dynamic reviewDescription;
  dynamic reviewID;
  dynamic bookingId;
  List? reviewReply;

  late List<String?> reviewImages;

  Map<String, int> reviewStatusList = {
    'Show': 1,
    'Hide': 2,
  };

  Future<void> changeReviewAvailablility() async {
    try {
      TaskerReview taskerReview = TaskerReview();
      final response = await taskerReview.changeReviewAvailablility(
          int.parse(reviewID), int.parse(reviewStatus));

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(response['data']['message'])),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception(response['data']['message']);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Error: ${error.toString()}')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String convertDateTime(String originalDateTime) {
    DateTime dateTime = DateTime.parse(originalDateTime);
    String formattedDateTime =
        DateFormat('d MMMM yyyy hh:mm a').format(dateTime);
    return formattedDateTime;
  }

  Future<void> replyreview() async {
    TaskerReview taskerReview = TaskerReview();
    final response = await taskerReview.replyreview(
      int.parse(reviewID),
      replyController.text,
    );

    if (response['statusCode'] == 200) {
      // Add the new reply to the list
      final newReply = {
        'reply_message': replyController.text,
        'reply_date_time': DateTime.now().toIso8601String(), // Current time
      };
      setState(() {
        reviewReply = (reviewReply ?? [])..add(newReply);
      });
      replyController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      throw Exception(response['data']['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    bookingOrderId = '${widget.bookingOrderId}';
    reviewRating = '${widget.reviewRating}';
    clientFLName = '${widget.clientFLName}';
    reviewDateTime = '${widget.reviewDateTime}';
    reviewStatus = '${widget.reviewStatus}';
    reviewDescription = '${widget.reviewDescription}';
    reviewID = '${widget.reviewID}';
    bookingId = '${widget.bookingId}';
    reviewReply = widget.reviewReply;

    reviewImages = [
      widget.reviewImageOne,
      widget.reviewImageTwo,
      widget.reviewImageThree,
      widget.reviewImageFour,
    ].where((image) => image != null && image.isNotEmpty).toList();

    replyController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Check if the replyController's text is empty
    setState(() {
      iconOpacity = replyController.text.isEmpty ? 0.3 : 1.0;
    });
  }

  @override
  void dispose() {
    replyController.removeListener(_onTextChanged);
    replyController.dispose();
    super.dispose();
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
          'Review Management',
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
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$bookingOrderId',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: List.generate(
                              5,
                              (index) => FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: index < int.parse(reviewRating)
                                    ? Colors.orange
                                    : Colors.grey,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            clientFLName,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        reviewDateTime,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownMenu(
                            items: reviewStatusList.keys.toList(),
                            titleSelect: 'Select Review Visibility',
                            titleValue: reviewStatusList.keys.firstWhere(
                              (key) =>
                                  reviewStatusList[key] ==
                                  int.parse(reviewStatus),
                            ),
                            onSelected: (selectedValue) {
                              setState(() {
                                reviewStatus =
                                    reviewStatusList[selectedValue].toString();
                              });
                              changeReviewAvailablility();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: reviewImages.length,
                      itemBuilder: (context, index) {
                        final imageUrl = reviewImages[index];
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? Image.network(
                                    '${dotenv.env['DOMAIN']}/storage/$imageUrl',
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox.shrink());
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                clientFLName,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Text(
                                reviewDateTime,
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
                            reviewDescription,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 12, top: 12, right: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.reviewReply != null &&
                        widget.reviewReply!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.reviewReply!.length,
                        itemBuilder: (context, index) {
                          final reply = widget.reviewReply![index];
                          return Column(
                            children: [
                              
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'You',
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
                                              reply['reply_date_time']),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      reply['reply_message'],
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index != widget.reviewReply!.length - 1)
                                SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    if (widget.reviewReply == null ||
                        widget.reviewReply!.isEmpty)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Text(
                              'No replies yet.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                          labelText: 'Your Message',
                          controller: replyController)),
                  SizedBox(width: 7.5),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (replyController.text != '') {
                          replyreview();
                        } else {
                          print("replyController is empty");
                        }
                      },
                      icon: Opacity(
                        opacity:
                            iconOpacity, // Change the opacity based on the controller's text
                        child: FaIcon(
                          FontAwesomeIcons.solidPaperPlane,
                          size: 15,
                          color: Colors.blue,
                        ),
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
