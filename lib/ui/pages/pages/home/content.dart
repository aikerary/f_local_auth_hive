import 'package:flutter/material.dart';

import 'home_page.dart';
import 'profile_page.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('contentScaffold'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth > 800 ? 800 : double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: constraints.maxWidth > 800
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    )
                  : null,
              child: Column(
                children: [
                  Expanded(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                  BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.verified_user),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.amber[800],
                    onTap: _onItemTapped,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.blueGrey[50], // Background for separation
    );
  }
}
