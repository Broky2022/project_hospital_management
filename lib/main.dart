import 'package:flutter/material.dart';
import 'package:project_hospital_management/main_layout.dart';
import 'package:project_hospital_management/models/auth_model.dart';
import 'package:project_hospital_management/screens/booking_page.dart';
import 'package:project_hospital_management/screens/doctor_details.dart';
import 'package:project_hospital_management/screens/success.booked.dart';
import 'utils/config.dart';
import 'screens/auth_page.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //định dạng màu nền
    return ChangeNotifierProvider<AuthModel> (
      create: (context) => AuthModel(),

    child: MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Project manager hospital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Config.primaryColor,
          border: Config.outlinedBorder,
          focusedBorder: Config.focusBorder,
          errorBorder: Config.errorBorder,
          enabledBorder: Config.outlinedBorder,
          floatingLabelStyle: TextStyle(color: Config.primaryColor),
          prefixIconColor: Colors.black38,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Config.primaryColor,
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey.shade700,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/',
      routes: {
        //Đây là route (đường dẫn) khởi đầu của ứng dụng
        //Route này sẽ dẫn đến trang xác thực (authentication) bao gồm phần đăng nhập và đăng ký
        '/': (context) => const AuthPage(),
        'main': (context) => const MainLayout(),
        'doc_details': (context) => const DoctorDetails(),
        'booking_page': (context) => BookingPage(),
        'success_booking': (context) => const AppointmentBooked(),
      },
    ),
    );
  }
}
