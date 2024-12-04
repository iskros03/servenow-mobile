import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:servenow_mobile/screens/add_service.dart';
import 'package:servenow_mobile/screens/home.dart';
import 'package:servenow_mobile/screens/my_address.dart';
import 'package:servenow_mobile/screens/my_profile.dart';
import 'package:servenow_mobile/screens/settings.dart';
import 'package:servenow_mobile/screens/services.dart';
import 'package:servenow_mobile/screens/sign_in.dart';
import 'package:servenow_mobile/screens/sign_up.dart';

Future<void> main() async {
  await dotenv.load(); 
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/sign_in',
    routes: {
      '/home': (context) => const Home(),
      '/sign_in': (context) => const SignIn(),
      '/sign_up': (context) => const SignUp(),
      '/settings': (context) => const Settings(),
      '/my_profile': (context) => const MyProfile(),
      '/services': (context) => const Services(),
      '/add_service': (context) => const AddService(),
      '/my_address': (context) => const MyAddress()
    }
  ));
}