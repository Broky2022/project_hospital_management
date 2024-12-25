import 'package:flutter/material.dart';
import 'package:project_hospital_management/main_layout.dart';
import 'utils/config.dart';
import 'screens/auth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //định dạng màu nền
    return MaterialApp(
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
        '/' : (context) => const AuthPage(),
        'main' : (context) => const MainLayout(),
      },

    );
  }
}