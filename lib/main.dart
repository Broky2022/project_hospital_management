import 'package:flutter/material.dart';
import 'package:project_hospital_management/models/user.dart';
import 'package:project_hospital_management/view/homepage.dart';
import '../view/login_forms.dart';
import '../view/signup_form.dart';
import 'view/doctorhomepage.dart';
import 'view/patienthomepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Management App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(), // Trang Home chung
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;

    // Dựa vào vai trò để điều hướng tới trang phù hợp
    if (user.role == 'doctor') {
      return DoctorHomePage(user: user);
    } else {
      return PatientHomePage(user: user);
    }
  }
}
