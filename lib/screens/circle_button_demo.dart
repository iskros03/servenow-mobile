import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, String>> bookings = [
    {
      'id': 'SRW-20-2025-1837259145',
      'service': 'Gardening',
      'date': '20 January 2025',
      'time': '9:00 AM - 10:30 AM',
    },
    {
      'id': 'SRW-19-2025-1737259145',
      'service': 'Cleaning',
      'date': '19 January 2025',
      'time': '7:00 AM - 8:00 AM',
    },
    {
      'id': 'SRW-21-2025-1937259145',
      'service': 'Laundry',
      'date': '21 January 2025',
      'time': '11:00 AM - 12:00 PM',
    },
    {
      'id': 'SRW-21-2025-1937259145',
      'service': 'Laundry',
      'date': '21 January 2025',
      'time': '11:00 AM - 12:00 PM',
    },
    {
      'id': 'SRW-21-2025-1937259145',
      'service': 'Laundry',
      'date': '21 January 2025',
      'time': '11:00 AM - 12:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                        color: Color.fromRGBO(24, 52, 92, 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Earnings',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Inter',
                                      color: Colors.white)),
                              Text('RM 1954.00',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Your Rank Level',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Inter',
                                      color: Colors.white)),
                              Text('Elite Tasker',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Satisfication',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Inter',
                                      color: Colors.white)),
                              Text('4 Star',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.5),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(7.5),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text('RM 34.00',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700])),
                                  Text('This Month',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text('RM 19.00',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700])),
                                  Text('This Year',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text('3 / 20',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700])),
                                  Text('Bookings',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text('0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[700])),
                                  Text('Penalty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text('4.0/5.0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700])),
                                  Text('Average Rating',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text('Happy',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700])),
                                  Text('Verdict',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Inter',
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.5),
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(7.5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: ListView.builder(
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.5, horizontal: 7.5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(7.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${index + 1}.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking['id']!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Inter',
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              booking['service']!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              booking['date']!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              booking['time']!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index != bookings.length - 1)
                                    SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.5),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Montly Revenue by Status',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700),
                          ),
                          SizedBox(height: 7.5),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Complete Booking',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade600),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.solidCircleCheck,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '3',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Floating Booking',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange.shade600),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.ghost,
                                            size: 18,
                                            color: Colors.orange,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 10),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yearly Revenue by Status',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700),
                          ),
                          SizedBox(height: 7.5),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Complete Booking',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade600),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.solidCircleCheck,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Floating Booking',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange.shade600),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.ghost,
                                            size: 18,
                                            color: Colors.orange,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
