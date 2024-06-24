import 'package:flutter/material.dart';
import 'add_hall_page.dart';
import 'recycler_view_page.dart';
import 'database_page.dart';
import 'about_page.dart';
import 'profile_page.dart';
import 'reservations_page.dart';  // Add this import
import 'package:firebase_auth/firebase_auth.dart';  // Add this import

class HomePage extends StatefulWidget {
  final String email;  // Add this line

  HomePage({required this.email});  // Add this line

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    RecyclerViewPage(),
    DatabasePage(),
    AboutPage(),
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
      appBar: AppBar(
        title: Text('EventPerfect'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Database',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddHallPage(),
                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: 'Add Hall',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReservationsPage(email: widget.email),
                ),
              );
            },
            child: Icon(Icons.list),
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: 'View Reservations',
          ),
        ],
      ),
    );
  }
}
