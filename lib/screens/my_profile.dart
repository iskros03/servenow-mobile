import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

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

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController icController = TextEditingController();
  String birthdate = ''; // Birthdate
  String photo = '';
  String email = '';
  int taskerStatus = 0;
  String icNum = '';

  // Address
  TextEditingController addressLineOneController = TextEditingController();
  TextEditingController addressLineTwoController = TextEditingController();
  TextEditingController addressPostalCodeController = TextEditingController();
  String? addressState;
  String? addressArea;

  @override
  void initState() {
    super.initState();
    taskerDataFuture = _loadTaskerData();
    fetchStateNames();

    icController.addListener(() {
      _updateBirthdateFromIC(icController.text);
    });
  }

  void _updateBirthdateFromIC(String icNumber) {
    if (icNumber.length >= 6) {
      String extractedDate = icNumber.substring(0, 6);
      String yearPrefix = extractedDate.substring(0, 2);
      String month = extractedDate.substring(2, 4);
      String day = extractedDate.substring(4, 6);

      int yearPrefixInt = int.parse(yearPrefix);

      String year;
      if (yearPrefixInt > 50) {
        year = '19$yearPrefix';
      } else {
        year = '20$yearPrefix';
      }

      birthdate = '$year-$month-$day';

      if (icNumber.length >= 12) {
        setState(() {});
      }
    }
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

  void fetchAreaNames(String selectedArea) async {
    TaskerUser getArea = TaskerUser();
    try {
      final areaNames = await getArea.getArea(selectedArea);
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
      var data = await taskerUser.getTaskerData();

      firstnameController.text = data[0]['tasker_firstname'];
      lastnameController.text = data[0]['tasker_lastname'];
      mobileController.text = data[0]['tasker_phoneno'];
      photo = data[0]['tasker_photo'];
      email = data[0]['email'];
      bioController.text = data[0]['tasker_bio'];
      icController.text = data[0]['tasker_icno'];
      birthdate = data[0]['tasker_dob'];
      // Address
      addressLineOneController.text = data[0]['tasker_address_one'];
      addressLineTwoController.text = data[0]['tasker_address_two'];
      addressPostalCodeController.text = data[0]['tasker_address_poscode'];
      addressState = data[0]['tasker_address_state'];
      addressArea = data[0]['tasker_address_area'];
      taskerStatus = data[0]['tasker_status'];
      icNum = data[0]['tasker_icno'];

      initialTaskerData = {
        'tasker_firstname': data[0]['tasker_firstname'],
        'tasker_lastname': data[0]['tasker_lastname'],
        'tasker_email': data[0]['email'],
        'tasker_mobile': data[0]['tasker_phoneno'],
        'tasker_photo': data[0]['tasker_photo'],
        'tasker_bio': data[0]['tasker_bio'],
        'tasker_icno': data[0]['tasker_icno'],
        'tasker_dob': data[0]['tasker_dob'],
        'tasker_status': data[0]['tasker_status'],
        // Address
        'tasker_address_one': data[0]['tasker_address_one'],
        'tasker_address_two': data[0]['tasker_address_two'],
        'tasker_address_poscode': data[0]['tasker_address_poscode'],
        'tasker_address_state': data[0]['tasker_address_state'],
        'tasker_address_area': data[0]['tasker_address_area'],
      };
      return initialTaskerData;
    } catch (e) {
      print('Error occurred: $e');
      return {};
    }
  }

  void _saveProfile() async {
    String icNumber = icController.text.trim();

    if (icNumber.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'IC Number must be 12 characters long.',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Prepare the updated data
    final updatedData = {
      'tasker_firstname': firstnameController.text.trim(),
      'tasker_lastname': lastnameController.text.trim(),
      'tasker_phoneno': mobileController.text.trim(),
      'tasker_photo': photo,
      'email': email,
      'tasker_bio': bioController.text,
      'tasker_icno': icNumber, // Use the validated IC number
      'tasker_dob': birthdate,
      'tasker_address_one': addressLineOneController.text,
      'tasker_address_two': addressLineTwoController.text,
      'tasker_address_poscode': addressPostalCodeController.text.trim(),
      'tasker_address_state': addressState,
      'tasker_address_area': addressArea,
    };

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade200,
          content: Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey.shade800,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          duration: Duration(seconds: 3),
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
            content: Center(
              child: Text(
                responseData['message'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
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
          content: Center(
            child: Text(
              '$error',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
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
    mobileController.dispose();
    icController.removeListener(() {});
    icController.dispose();
    bioController.dispose();

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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(24, 52, 92, 1),
          title: Text(
            'Personal Details',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 16,
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
          actions: [
            TextButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.orange[300],
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: Center(
                //     child: Container(
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //           color: Colors.grey.shade500,
                //           width: 1.5,
                //         ),
                //       ),
                //       child: CircleAvatar(
                //         radius: 45,
                //         backgroundImage: NetworkImage(
                //             'https://servenow.com.my/storage/$photo'
                //             ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Biodata',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.grey[800]),
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField(
                    'First Name', firstnameController, 'Enter first name'),
                SizedBox(height: 10),
                _buildTextField(
                    'Last Name', lastnameController, 'Enter last name'),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: [
                      taskerStatus == 2
                          ? Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'IC Number',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12.5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      border: Border.all(
                                          color: Colors.grey.shade100),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      icNum,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: Colors.grey[500]),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              flex: 3,
                              child: _buildTextField(
                                  'IC Number', icController, 'Enter IC Number',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 12),
                            ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Birthdate',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.5),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                birthdate,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.grey[500]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Contact',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.grey[800]),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Email',
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.5),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          email,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField(
                  'Mobile',
                  mobileController,
                  'Enter your mobile',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 10),
                _buildTextField('Bio', bioController, 'Enter bio', maxLines: 3),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Address',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.grey[800]),
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField('Address Line 1', addressLineOneController,
                    'Enter Address Line 1'),
                SizedBox(height: 10),
                _buildTextField('Address Line 2', addressLineTwoController,
                    'Enter Address Line 2'),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'State',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Inter',
                                    fontSize: 12),
                              ),
                            ),
                            CustomDropdownMenu(
                              items: states,
                              titleSelect: 'Select State',
                              titleValue: addressState ?? 'Select State',
                              onSelected: (selectedValue) {
                                setState(() {
                                  addressState = selectedValue;
                                  addressArea = null;
                                });
                                fetchAreaNames(selectedValue);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 3,
                        child: _buildTextField('Postal Code',
                            addressPostalCodeController, 'Enter Postal Code'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Area',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: 'Inter',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      CustomDropdownMenu(
                        items: areas,
                        titleSelect: 'Select Area',
                        titleValue: addressArea ?? 'Select Area',
                        onSelected: (selectedValue) {
                          setState(() {
                            addressArea = selectedValue;
                          });
                        },
                        isEnabled: states.isNotEmpty,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      int maxLines = 1,
      List<TextInputFormatter>? inputFormatters,
      int? maxLength}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
          CustomTextField(
            labelText: hintText,
            maxLines: maxLines,
            controller: controller,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            maxLength: maxLength, // Pass maxLength here
          ),
        ],
      ),
    );
  }
}
