import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:servenow_mobile/services/tasker_user.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void _savePassword() async {
    final updatedPassword = {
      'oldPass': oldPasswordController.text,
      'newPass': newPasswordController.text,
      'renewPass': confirmPasswordController.text,
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
      TaskerAuth taskerAuth = TaskerAuth();
      final taskerData = await taskerUser.getTaskerData();
      String taskerID = taskerData[0]['id'].toString();
      final response =
          await taskerAuth.updateTaskerPassword(taskerID, updatedPassword);

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
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
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
                fontWeight: FontWeight.normal,
                fontSize: 13,
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(24, 52, 92, 1),
          title: Text(
            'Change Password',
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
              onPressed: _savePassword,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  'Old Password', oldPasswordController, 'Enter old password',
                  obscureText: true),
              SizedBox(height: 10),
              _buildTextField(
                  'New Password', newPasswordController, 'Enter new password',
                  obscureText: true),
              SizedBox(height: 10),
              _buildTextField('Confirm Password', confirmPasswordController,
                  'Enter confirm password',
                  obscureText: true),
            ],
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
            maxLength: maxLength,
          ),
        ],
      ),
    );
  }
}
