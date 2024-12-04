// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String taskerFirstName = '';
  String taskerSettingsPhoto = '';

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
        taskerSettingsPhoto = data[0]['tasker_photo'];
      });
      print('Fetched Data: $data');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(24, 52, 92, 1),
      ),
      backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(taskerFirstName,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          'Rosmi',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.green,
                          ),
                          padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical:2.5),
                          child: Text(
                            'Active',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://servenow.com.my/storage/$taskerSettingsPhoto'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
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
                                      'Account & Security',
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
                                      Navigator.pushNamed(context, '/my_profile');
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
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
                                      'My Address',
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
                                      Navigator.pushNamed(context, '/my_address');
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
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
                                      'Bank Accounts / Cards',
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
