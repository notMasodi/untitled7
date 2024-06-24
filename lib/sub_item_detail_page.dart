import 'package:flutter/material.dart';
import 'package:untitled7/splash_screen.dart';
import 'sub_item.dart';
import 'package:firebase_database/firebase_database.dart';

class SubItemDetailPage extends StatelessWidget {
  final SubItem subItem;
  final DateTime selectedDate;
  final String email;  // Add email

  SubItemDetailPage({required this.subItem, required this.selectedDate, required this.email});

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  void _reserveHall(BuildContext context) {
    String reservationDate = selectedDate.toIso8601String().split('T').first;
    String reservationId = _databaseReference.child('Hall/${subItem.id}/reservations').push().key!;
    _databaseReference.child('Hall/${subItem.id}/reservations/$reservationId').set({
      'date': reservationDate,
      'email': email,  // Add email to reservation
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation successful')),
      );
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reserve hall: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subItem.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              subItem.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subItem.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < subItem.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    subItem.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                        'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                        'nisi ut aliquip ex ea commodo consequat.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: Image.network(
                        'https://static-maps.yandex.ru/1.x/?ll=44.2182114,15.3215471&size=650,450&z=20&l=map&pt=44.2182114,15.3215471,pm2rdm',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _reserveHall(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Center(
                      child: Text('Reserve Hall', style: TextStyle(
                        color: color4,
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
