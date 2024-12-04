import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String taskerFirstName = '';
  String taskerProfilePhoto = '';

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
      });
      print('Fetched Data: $data');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: const Color.fromRGBO(24, 52, 92, 1),
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 22.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Good Afternoon, $taskerFirstName',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Inter'),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomCard(
                                  cardColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Earning',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Inter',
                                                      color: Colors.grey[600])),
                                              Text('RM 129.00',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[800])),
                                            ],
                                          ),
                                          Text(
                                            'Change will take up to 5 minutes',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          width: 75,
                                          child: FaIcon(FontAwesomeIcons.coins   ,
                                              color: Colors.orange.shade700, size: 50.0))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.5),
                          Row(
                            children: [
                              Expanded(
                                child: CustomCard(
                                  cardColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Upcoming Job',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Inter',
                                                      color: Colors.grey[600])),
                                              Text('6',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[800])),
                                            ],
                                          ),
                                          Text(
                                            'Change will take up to 5 minutes',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          width: 75,
                                          child: FaIcon(
                                              FontAwesomeIcons.accusoft,
                                              color: Colors.blue,
                                              size: 50.0))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ), // Border radius
                ),
                child: Column(
                  children: [
                    CustomCard(
                      cardColor: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 7.5),
                                  Text(
                                    'Notification',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Change will take up to 5 minutes',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: 12,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        children: [
                          CustomCard(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            cardColor: Colors.grey.shade100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.home_repair_service,
                                      size: 20,
                                      color: Color.fromRGBO(24, 52, 92, 1),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Services',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/services');
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.chevronRight,
                                      size: 12,
                                    ))
                              ],
                            ),
                          ),

                          CustomCard(
                            cardColor: Colors.grey.shade100,
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.home_repair_service,
                                      size: 20,
                                      color: Color.fromRGBO(24, 52, 92, 1),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Task Preferences',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: FaIcon(
                                      FontAwesomeIcons.chevronRight,
                                      size: 12,
                                    ))
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
