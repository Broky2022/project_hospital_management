import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_hospital_management/screens/appointment_page.dart';
import 'package:project_hospital_management/screens/home_page.dart';
>>>>>>> thuan

class MainLayout extends StatefulWidget{
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>{
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Scaffold();
=======
  //variable declaration
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            //update page when tab pressed
            currentPage = value;
          });
        }),
        children: const <Widget>[
          HomePage(),
          AppointmentPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(
                page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Appointments',
          ),
        ],
      ),
    );
>>>>>>> thuan
  }
}