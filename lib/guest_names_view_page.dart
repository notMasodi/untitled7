import 'package:flutter/material.dart';

class GuestNamesViewPage extends StatelessWidget {
  final List<String> guestNames;

  GuestNamesViewPage({required this.guestNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Names'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: guestNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(guestNames[index]),
          );
        },
      ),
    );
  }
}
