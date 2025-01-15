import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/widgets/custom_icon_button.dart';
import 'package:servenow_mobile/widgets/custom_text_button.dart';

class ReviewList extends StatefulWidget {
  const ReviewList({super.key});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  List<dynamic> reviews = []; // List service from specific tasker
  List<dynamic> serviceType = []; // List service type
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> getServiceStatus(int status) {
    switch (status) {
      case 0:
        return {
          'text': 'Pending',
          'color': Colors.orange[50],
          'textColor': Colors.orange[500]
        };
      case 1:
        return {
          'text': 'Active',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 2:
        return {
          'text': 'Inactive',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 3:
        return {
          'text': 'Rejected',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 4:
        return {
          'text': 'Teminated',
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

  String capitalizeFirstLetter(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] =
          words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return words.join(' ');
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
            Padding(
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => FaIcon(
                                  FontAwesomeIcons.star,
                                  color:
                                      index < 4 ? Colors.orange : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.5),
                                  color: Colors.grey[50]),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                'SRW-15-01-2025-1736964709',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                'Isk Ros',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),
                              ),
                              Spacer(),
                              Text(
                                '16 January 2025 2:16 AM',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                          border: Border.all(
                              width: 1, color: Colors.grey.shade300)),
                      child: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: Colors.green[50]),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Text(
                            'Show',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.green[500]),
                          ),
                        ),
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
                            onPressed: () {},
                            icon: FaIcon(
                              FontAwesomeIcons.pen,
                              size: 15,
                              color: Colors.blue, // Icon color
                            ),
                            splashColor:
                                Colors.transparent, // Removes the splash effect
                            highlightColor: Colors
                                .transparent, // Removes the highlight effect
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
