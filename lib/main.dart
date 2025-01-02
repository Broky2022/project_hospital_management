import 'dart:io';
import 'dart:typed_data'; // Chỉ import thư viện cần thiết
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_form.dart';
import 'screens/doctor_home.dart';
import 'screens/patient_home.dart';
import 'screens/HomeMain.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Thêm async
  // Đảm bảo Flutter binding được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // Cấu hình channel buffer
  ServicesBinding.instance.defaultBinaryMessenger.setMessageHandler(
    'flutter/lifecycle',
    (ByteData? message) async {
      return null;
    },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Medical App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        home: MainView(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, authProvider, __) {
        if (authProvider.userRole == null) {
          return LoginScreen();
        }
        return authProvider.userRole == 'doctor' ? DoctorHome() : PatientHome();
      },
    );
  }
}
