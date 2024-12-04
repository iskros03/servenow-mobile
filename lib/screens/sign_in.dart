import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_auth.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';
import 'package:servenow_mobile/widgets/custom_text_button.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create an instance of TaskerAuth
  final TaskerAuth taskerAuth = TaskerAuth();

  void getSignIn() {
    String email = emailController.text;
    String password = passwordController.text;
    taskerAuth.getTaskerAuth(context, email, password);
  }

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
                    obscureText: true,
                    labelText: 'Password',
                    controller: passwordController,
                  ),
                  Container(
                      padding: const EdgeInsets.all(12.5),
                      child: CustomTextButton(
                          text: 'Forgot Password?', onPressed: () {})),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      child: CustomEleButton(
                          borderRadius: 10,
                          borderWidth: 0,
                          fgColor: Colors.white,
                          bgColor: const Color.fromRGBO(24, 52, 92, 1),
                          text: 'Sign In',
                          onPressed: () {
                            getSignIn();
                          })),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                      CustomTextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign_up');
                          },
                          text: 'Sign Up'),
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
