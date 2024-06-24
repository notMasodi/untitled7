import 'package:flutter/material.dart';

class SubItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  SubItemWidget({required this.title, required this.description, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
        ),
        subtitle: Text(description, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
      ),
    );
  }
}
