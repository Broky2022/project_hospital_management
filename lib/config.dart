import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'profilepage.dart';

class CardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Care Example'),
        ),
        body: Center(
          child: Card(
            elevation: 4.0, //độ phủ bóng
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('This is a card'),
            ),
          ),
        ),
      ),
    );
  }
}

class ImgExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Circle Avatar Example'),
        ),
        body: Center(
          child: CircleAvatar(
            radius: 100, //bán kính avt
            backgroundImage: NetworkImage('https://picsum.photos/200/200'),
          ),
        ),
      ),
    );
  }
}

class BorderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Border Example'),
        ),
        body: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.greenAccent,
                width: 3,
              ),
            ),
            child: Center(
              child: Text('Border'),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget> [
    homeScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BottomNavigationBar Example'),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex, //chỉ mục trang đc chọn
          selectedItemColor: Colors.amber[800], //màu của trang được chọn
          onTap: _onItemTapped, //hàm xử lý khi được nhấn
        ),
      ),
    );
  }
}


