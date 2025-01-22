import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true; 

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  Future<void> getSignIn() async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      // Check for empty email or password
      if (email.isEmpty || password.isEmpty) {
        String errorMessage;
        if (email.isEmpty && password.isEmpty) {
          errorMessage = 'Email and password cannot be empty.';
        } else if (email.isEmpty) {
          errorMessage = 'Email cannot be empty.';
        } else {
          errorMessage = 'Password cannot be empty.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                errorMessage,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return; // Stop further execution
      }

      // Validate email format
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
                child: Text(
              'Please enter a valid email address.',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            )),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return; // Stop further execution
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade200,
          content: Center(
            child: Text(
              'Login...',
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

      final taskerAuth = TaskerAuth();
      final data = await taskerAuth.getTaskerAuth(context, email, password);

      if (data['statusCode'] == 200) {
        final token = data['data']['token'];
        await taskerAuth.saveToken(token);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final errorMessage = data['data']['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                errorMessage,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Error: ${e.toString()}',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Image(
                        image: AssetImage('assets/serveNowLogo.png'),
                        width: 125)),
                const SizedBox(height: 30),
                Text(
                  'Sign In',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[700]),
                ),
                Text(
                  'Please log in using valid credentials.',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  labelText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  obscureText: obscurePassword,
                  labelText: 'Password',
                  controller: passwordController,
                  onEyeTap:
                      togglePasswordVisibility, // Toggle password visibility
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    child: CustomEleButton(
                        borderRadius: 10,
                        borderWidth: 0,
                        fgColor: Colors.white,
                        bgColor: Color.fromRGBO(24, 52, 92, 1),
                        text: 'Sign In',
                        onPressed: () {
                          getSignIn();
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
