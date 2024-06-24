
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String name;
  final String age;

  DetailPage({required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 10),
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}