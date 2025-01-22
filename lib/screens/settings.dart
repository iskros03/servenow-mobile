import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    _loadTaskerData();
  }

  String taskerFirstName = '';
  String taskerLastName = '';
  String taskerSettingsPhoto = '';
  String taskerCode = '';
  String taskerEmail = '';
  int taskerStatus = 10;

  void _loadTaskerData() async {
    TaskerUser taskerUser = TaskerUser();
    try {
      var data = await taskerUser.getTaskerData();
      setState(() {
        taskerFirstName = data[0]['tasker_firstname'];
        taskerLastName = data[0]['tasker_lastname'];
        taskerSettingsPhoto = data[0]['tasker_photo'];
        taskerCode = data[0]['tasker_code'];
        taskerStatus = data[0]['tasker_status'];
        taskerEmail = data[0]['email'];
      });
      print('Fetched Data: $data');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _logout() async {
    TaskerAuth taskerAuth = TaskerAuth();
    try {
      bool isLoggedOut = await taskerAuth.getTaskerLogout();
      if (isLoggedOut) {
        Navigator.pushReplacementNamed(context, '/sign_in');
        print('Logout successful.');
      } else {
        print('Failed to log out.');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Map<String, dynamic> getTaskerStatus(int taskerStatus) {
    switch (taskerStatus) {
      case 0:
        return {
          'text': 'Incomplete Profile',
          'color': Colors.orange[50],
          'textColor': Colors.orange[500]
        };
      case 1:
        return {
          'text': 'Not Verified',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 2:
        return {
          'text': 'Verified & Active',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 3:
        return {
          'text': 'Inactive',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 10:
        return {
          'text': '',
          'color': Colors.transparent,
          'textColor': Colors.transparent
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
    }
  }

  void _showLogoutConfirmation() {
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
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Are you sure you want to Sign out? You will need to log in again to access your account.',
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
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.red[50],
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
                          'Sign Out',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(24, 52, 92, 1),
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          title: const Text(
            'Settings',
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
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(taskerFirstName,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(
                      taskerLastName,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      taskerEmail,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      taskerCode,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.orange.shade300,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: getTaskerStatus(taskerStatus)['color'],
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.5)),
                          ),
                          child: Text(
                            getTaskerStatus(taskerStatus)['text'],
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color:
                                    getTaskerStatus(taskerStatus)['textColor'],
                                fontSize: 10),
                          ),
                        ),
                        // SizedBox(width: 10),
                        // Text(
                        //   taskerCode,
                        //   style: TextStyle(
                        //     fontFamily: 'Inter',
                        //     fontWeight: FontWeight.normal,
                        //     fontSize: 14,
                        //     color: Colors.orange.shade300,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      '${dotenv.env['DOMAIN']}/storage/$taskerSettingsPhoto',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/my_profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            'Personal Details',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            child: FaIcon(
                              FontAwesomeIcons.addressCard,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/change_password');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            'Change Password',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            child: FaIcon(
                              FontAwesomeIcons.lock,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _showLogoutConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5),
                          side: BorderSide(
                            color: Colors.red.shade50, // Border color
                            width: 2, // Border width
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      ).copyWith(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        shadowColor:
                            WidgetStateProperty.all(Colors.transparent),
                        surfaceTintColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
