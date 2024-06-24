import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReservationsPage extends StatefulWidget {
  final String email;

  ReservationsPage({required this.email});

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> _reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  void _fetchReservations() {
    _databaseReference.child('Hall').get().then((DataSnapshot snapshot) {
      List<Map<String, dynamic>> reservations = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value['reservations'] != null) {
            Map<dynamic, dynamic> reservationData = value['reservations'] as Map<dynamic, dynamic>;
            reservationData.forEach((resKey, resValue) {
              if (resValue['email'] == widget.email) {
                reservations.add({
                  'title': value['title'],
                  'date': resValue['date'],
                  'description': value['description'],
                  'imageUrl': value['image'],
                  'rating': value['rating'],
                });
              }
            });
          }
        });
      }
      setState(() {
        _reservations = reservations;
      });
    }).catchError((error) {
      print('Error fetching reservations: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reservations'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: _reservations.length,
        itemBuilder: (context, index) {
          final reservation = _reservations[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    reservation['imageUrl'],
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        reservation['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Date: ${reservation['date']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < reservation['rating'] ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
