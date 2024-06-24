import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'guest_list_page.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/yahya.jpg'),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yahya Alodhri',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '(+967) 771888999',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
          SizedBox(height: 20),
          _buildProfileOption(context, 'Wedding Details', FontAwesomeIcons.evernote),
          _buildProfileOption(context, 'Guest List', Icons.group, onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GuestListPage()),
            );
          }),
          _buildProfileOption(context, 'Notifications', Icons.notifications),
          _buildProfileOption(context, 'Budget', Icons.attach_money),
          _buildProfileOption(context, 'Favorite List', Icons.favorite),
          _buildProfileOption(context, 'Finalized Vendor', Icons.check),
          _buildProfileOption(context, 'Social Links', Icons.link),
          _buildProfileOption(context, 'Settings', Icons.settings),
          _buildProfileOption(context, 'Logout', Icons.logout, color: Colors.red, onTap: () => _signOut(context)),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, IconData icon, {Color color = Colors.black, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap ?? () {
        // Handle navigation for other options if needed
      },
    );
  }
}
