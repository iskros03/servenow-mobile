import 'package:flutter/material.dart';
import 'package:servenow_mobile/screens/task_preferences.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? taskerFirstName;
  String? taskerProfilePhoto;
  int? taskerStatus;

  @override
  void initState() {
    super.initState();
    _loadTaskerData();
  }

  void _loadTaskerData() async {
    TaskerUser taskerUser = TaskerUser();
    try {
      var data = await taskerUser.getTaskerData();
      setState(() {
        taskerFirstName = data[0]['tasker_firstname'];
        taskerProfilePhoto = data[0]['tasker_photo'];
        taskerStatus = data[0]['tasker_status'];
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
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
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                                      color: Colors.grey[600])),
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
                                      color: Colors.grey[600])),
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
                                      color: Colors.grey[600])),
                              Text('Bookings Completed',
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
                    SizedBox(height: 10),
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
                                      color: Colors.grey[600])),
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
                                      color: Colors.grey[600])),
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
                                      color: Colors.grey[600])),
                              Text('Bookings Completed',
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
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/services');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Services',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: FaIcon(
                                    FontAwesomeIcons.wrench,
                                    size: 20,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskPreferences(
                                          taskerStatus: taskerStatus,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Task Preferences',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: FaIcon(
                                    FontAwesomeIcons.briefcase,
                                    size: 20,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/my_booking');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Booking',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: FaIcon(
                                    FontAwesomeIcons.calendarCheck,
                                    size: 20,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/booking_summary');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Booking List',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: FaIcon(
                                    FontAwesomeIcons.calendarCheck,
                                    size: 20,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/review_summary');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Review Summary',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: FaIcon(
                                    FontAwesomeIcons.calendarCheck,
                                    size: 20,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/refund_booking_summary');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ).copyWith(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              surfaceTintColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Refund Booking Summary',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: FaIcon(
                                    FontAwesomeIcons.calendarCheck,
                                    size: 20,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
