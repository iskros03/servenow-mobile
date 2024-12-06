import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late Future<Map<String, String>> taskerDataFuture;
  late Map<String, String> initialTaskerData;

  List<String> states = [];
  List<String> areas = [];
  String? selectedState;
  String? selectedArea;
  int _selectedTabIndex = 0;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController icController = TextEditingController();
  String? birthdate; // Birthdate
  String? photo; // Photo
  // Address
  TextEditingController addressLineOneController = TextEditingController();
  TextEditingController addressLineTwoController = TextEditingController();
  TextEditingController addressPostalCodeController = TextEditingController();
  String? addressState;
  String? addressArea;
  // Working Area
  String? workingLocState;
  String? workingLocArea;

  @override
  void initState() {
    super.initState();
    taskerDataFuture = _loadTaskerData();
    fetchStateNames();
  }

  void fetchStateNames() async {
    TaskerUser getState = TaskerUser();
    try {
      final stateNames = await getState.getState();
      setState(() {
        states = stateNames;
      });
      final taskerData = await taskerDataFuture;
      if (taskerData['tasker_address_state'] != null) {
        fetchAreaNames(taskerData['tasker_address_state']!);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchAreaNames(String selectedState) async {
    TaskerUser getArea = TaskerUser();
    try {
      final areaNames = await getArea.getArea(selectedState);
      setState(() {
        areas = areaNames;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Map<String, String>> _loadTaskerData() async {
    TaskerUser taskerUser = TaskerUser();
    try {
      await Future.delayed(const Duration(seconds: 1));
      var data = await taskerUser.getTaskerData();

      firstnameController.text = data[0]['tasker_firstname'];
      lastnameController.text = data[0]['tasker_lastname'];
      mobileController.text = data[0]['tasker_phoneno'];
      photo = data[0]['tasker_photo'];
      emailController.text = data[0]['email'];
      bioController.text = data[0]['tasker_bio'];
      icController.text = data[0]['tasker_icno'];
      birthdate = data[0]['tasker_dob'];
      // Address
      addressLineOneController.text = data[0]['tasker_address_one'];
      addressLineTwoController.text = data[0]['tasker_address_two'];
      addressPostalCodeController.text = data[0]['tasker_address_poscode'];
      addressState = data[0]['tasker_address_state'];
      addressArea = data[0]['tasker_address_area'];
      // Working Address
      workingLocState = data[0]['tasker_workingloc_state'];
      workingLocArea = data[0]['tasker_workingloc_area'];

      initialTaskerData = {
        'tasker_firstname': data[0]['tasker_firstname'],
        'tasker_lastname': data[0]['tasker_lastname'],
        'tasker_email': data[0]['email'],
        'tasker_mobile': data[0]['tasker_phoneno'],
        'tasker_photo': data[0]['tasker_photo'],
        'tasker_bio': data[0]['tasker_bio'],
        'tasker_icno': data[0]['tasker_icno'],
        'tasker_dob': data[0]['tasker_dob'],
        // Address
        'tasker_address_one': data[0]['tasker_address_one'],
        'tasker_address_two': data[0]['tasker_address_two'],
        'tasker_address_poscode': data[0]['tasker_address_poscode'],
        'tasker_address_state': data[0]['tasker_address_state'],
        'tasker_address_area': data[0]['tasker_address_area'],
        // Working Address
        'tasker_workingloc_state': data[0]['tasker_workingloc_state'],
        'tasker_workingloc_area': data[0]['tasker_workingloc_area'],
      };
      return initialTaskerData;
    } catch (e) {
      print('Error occurred: $e');
      return {};
    }
  }

  void _saveProfile() async {
    final updatedData = {
      'tasker_firstname': firstnameController.text.trim(),
      'tasker_lastname': lastnameController.text.trim(),
      'tasker_phoneno': mobileController.text.trim(),
      'tasker_photo': photo,
      'email': emailController.text.trim(),
      'tasker_bio': bioController.text,
      'tasker_icno': icController.text.trim(),
      'tasker_dob': birthdate,
      'tasker_address_one': addressLineOneController.text,
      'tasker_address_two': addressLineTwoController.text,
      'tasker_address_poscode': addressPostalCodeController.text.trim(),
      'tasker_address_state': addressState,
      'tasker_address_area': addressArea,
      'tasker_workingloc_state': workingLocState,
      'tasker_workingloc_area': workingLocArea,
    };

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving profile...'),
          duration: Duration(seconds: 1),
        ),
      );

      TaskerUser taskerUser = TaskerUser();
      final taskerData = await taskerUser.getTaskerData();
      String taskerID = taskerData[0]['id'].toString();

      final response = await taskerUser.updateTaskerData(taskerID, updatedData);
      final responseData = response['data'];

      if (response['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw responseData['message'];
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _savePassword() async {
    final updatedPassword = {
      'oldPass': oldPasswordController.text,
      'newPass': newPasswordController.text,
      'renewPass': confirmPasswordController.text,
    };
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving profile...'),
          duration: Duration(seconds: 2),
        ),
      );

      TaskerUser taskerUser = TaskerUser();
      TaskerAuth taskerAuth = TaskerAuth();
      final taskerData = await taskerUser.getTaskerData();
      String taskerID = taskerData[0]['id'].toString();
      final response =
          await taskerAuth.updateTaskerPassword(taskerID, updatedPassword);

      final responseData = response['data'];

      if (response['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw responseData['message'];
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    icController.dispose();
    bioController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    // Address
    addressLineOneController.dispose();
    addressLineTwoController.dispose();
    addressPostalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(24, 52, 92, 1),
          title: Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[500],
            labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
                fontSize: 13.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Personal Info'),
              Tab(text: 'Password'),
            ],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: _selectedTabIndex == 0 ? _saveProfile : _savePassword,
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.orange[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<Map<String, String>>(
          future: taskerDataFuture,
          builder: (context, snapshot) {
            // Waiting for request
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage('assets/serveNowLogo.png'), width: 100),
                  SpinKitThreeBounce(
                    color: Color.fromRGBO(24, 52, 92, 1),
                    size: 10.0,
                  ),
                ],
              ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading profile data.'));
            } else {
              return TabBarView(
                children: [
                  // Personal Info Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade500,
                                    width: 2.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(
                                      'https://servenow.com.my/storage/$photo'),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[300],
                                    endIndent:
                                        8, // Adds spacing between line and text
                                  ),
                                ),
                                Text(
                                  'Biodata',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[300],
                                    indent:
                                        8, // Adds spacing between text and line
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            'First Name',
                            firstnameController,
                            'Enter first name',
                          ),
                          _buildTextField('Last Name', lastnameController,
                              'Enter last name'),
                          Row(children: [
                            Expanded(
                                flex: 3,
                                child: _buildTextField('IC Number',
                                    icController, 'Enter ic number')),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 12.5),
                                      Text(
                                        'Birthdate',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.5),
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12.5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$birthdate',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            color: Colors.grey[500]),
                                      )),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            )
                          ]),
                          SizedBox(height: 50),
                          Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[300],
                                    endIndent:
                                        8, // Adds spacing between line and text
                                  ),
                                ),
                                Text(
                                  'Contact',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[300],
                                    indent:
                                        8, // Adds spacing between text and line
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            'Email',
                            emailController,
                            'Enter your email',
                          ),
                          _buildTextField(
                            'Mobile',
                            mobileController,
                            'Enter your mobile',
                          ),
                          _buildTextField('Bio', bioController, 'Enter bio',
                              maxLines: 3),
                          SizedBox(height: 50),
                          Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                    endIndent:
                                        8, // Adds spacing between line and text
                                  ),
                                ),
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                    indent:
                                        8, // Adds spacing between text and line
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            'Address Line 1',
                            addressLineOneController,
                            'Enter Address Line 1',
                          ),
                          _buildTextField(
                            'Address Line 2',
                            addressLineTwoController,
                            'Enter Address Line 2',
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 12.5),
                                        Text(
                                          'State',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontFamily: 'Inter',
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2.5),
                                    CustomDropdownMenu(
                                      items: states,
                                      titleSelect: 'Select State',
                                      titleValue: addressState,
                                      onSelected: (selectedValue) {
                                        setState(() {
                                          addressState = selectedValue;
                                          addressArea = '';
                                        });
                                        fetchAreaNames(selectedValue);
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  'Postal Code',
                                  addressPostalCodeController,
                                  'Enter Postal Code',
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 12.5),
                                  Text(
                                    'Area',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Inter',
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2.5),
                              CustomDropdownMenu(
                                items: areas,
                                titleSelect: 'Select Area',
                                titleValue: addressArea == ''
                                    ? 'Select Area'
                                    : addressArea,
                                onSelected: (selectedValue) {
                                  setState(() {
                                    addressArea = selectedValue;
                                  });
                                },
                                isEnabled: states.isNotEmpty,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCard(
                            cardColor: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.circleInfo,
                                      color: Colors.blue[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 7.5),
                                    Text(
                                      'Note',
                                      style: TextStyle(
                                          color: Colors.blue[600],
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
                          ),
                          _buildTextField('Old Password', oldPasswordController,
                              'Enter old password',
                              obscureText: true),
                          _buildTextField('New Password', newPasswordController,
                              'Enter new password',
                              obscureText: true),
                          _buildTextField(
                              'Confirm Password',
                              confirmPasswordController,
                              'Enter confirm password',
                              obscureText: true),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 12.5),
            Text(
              label,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 2.5),
        CustomTextField(
          labelText: hintText,
          maxLines: maxLines,
          controller: controller,
          obscureText: obscureText,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
