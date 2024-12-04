import 'package:flutter/material.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';
import 'package:servenow_mobile/widgets/custom_text_button.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Image(
                          image: AssetImage('assets/serveNowLogo.png'),
                          width: 125)),
                  const SizedBox(height: 30),
                  Text(
                    'Sign Up',
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
                    labelText: 'First Name',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'Last Name',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    obscureText: true,
                    labelText: 'Password',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    obscureText: true,
                    labelText: 'Confirm Password',
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 22.5),
                  SizedBox(
                      width: double.infinity,
                      child: CustomEleButton(
                          borderRadius: 10,
                          borderWidth: 0,
                          fgColor: Colors.white,
                          bgColor: const Color.fromRGBO(24, 52, 92, 1),
                          text: 'Sign Up',
                          onPressed: () {})),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                      CustomTextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/my_profile');
                          },
                          text: 'Sign In'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
